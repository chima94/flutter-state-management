import 'package:bloc/bloc.dart';
import 'package:flutter_statemanagement/api/login_api.dart';
import 'package:flutter_statemanagement/api/note_api.dart';
import 'package:flutter_statemanagement/bloc/app_start.dart';
import 'package:flutter_statemanagement/bloc/bloc_action.dart';
import 'package:flutter_statemanagement/model.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi})
      : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      emit(const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null));

      final loginHandle =
          await loginApi.login(email: event.email, password: event.password);

      emit(AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null));
    });

    on<LoadNotesAction>((event, emit) async {
      emit(AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null));
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.fooBar()) {
        emit(AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null));
        return;
      }
      final notes = await notesApi.getNotes(loginHandle: loginHandle!);
      emit(AppState(
          isLoading: false,
          loginError: null,
          loginHandle: loginHandle,
          fetchedNotes: notes));
    });
  }
}
