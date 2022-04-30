import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_event.dart';
import 'package:flutter_statemanagement/bloc/app_state.dart';
import 'package:flutter_statemanagement/dialog/loading_screen.dart';
import 'package:flutter_statemanagement/dialog/show_auth_error.dart';
import 'package:flutter_statemanagement/views/login_view.dart';
import 'package:flutter_statemanagement/views/photo_gallary_view.dart';
import 'package:flutter_statemanagement/views/register_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitializer()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Photo Library',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocConsumer<AppBloc, AppState>(listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(context: context, text: 'Loading');
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(context: context, authError: authError);
            }
          }, builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGallery();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              return Container();
            }
          })),
    );
  }
}
