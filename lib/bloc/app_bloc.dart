import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_event.dart';
import 'package:flutter_statemanagement/bloc/app_state.dart';
import 'package:flutter_statemanagement/utils/upload_image.dart';
import '../auth/auth_error.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    on<AppEventLogin>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      final email = event.email;
      final password = event.password;
      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = userCredential.user!;
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
      } on FirebaseAuthException catch (e) {
        print(e);
        emit(AppStateLoggedOut(isLoading: false, authError: AuthError.from(e)));
      }
    });

    on<AppEventGoToLogin>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: false));
    });

    on<AppEventGoToRegistration>((event, emit) async {
      emit(const AppStateIsInRegistrationView(isLoading: false));
    });

    on<AppEventRegister>((event, emit) async {
      emit(const AppStateIsInRegistrationView(isLoading: true));
      final email = event.email;
      final password = event.password;
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        emit(AppStateLoggedIn(
            isLoading: false, user: credential.user!, images: const []));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventInitializer>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      final images = await _getImages(user.uid);
      emit(
        AppStateLoggedIn(isLoading: false, user: user, images: images),
      );
    });

    on<AppEventLogout>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut(isLoading: false));
    });

    on<AppEventDeletAccount>((event, emit) async {
      final user = state.user;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      emit(AppStateLoggedIn(
          isLoading: true, user: user, images: state.images ?? []));
      try {
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {});
        }
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        await user.delete();
        await FirebaseAuth.instance.signOut();

        emit(const AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e)));
      } on FirebaseException {
        emit(const AppStateLoggedOut(isLoading: false));
      }
    });

    on<AppEventUploadImage>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(const AppStateLoggedOut(isLoading: false));
          return;
        }
        emit(AppStateLoggedIn(
            isLoading: true, user: user, images: state.images ?? []));
        final file = File(event.filePathToUpload);
        await uploadImage(file: file, userId: user.uid);
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
