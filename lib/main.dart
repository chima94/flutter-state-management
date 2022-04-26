import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statemanagement/api/login_api.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_start.dart';
import 'package:flutter_statemanagement/bloc/bloc_action.dart';
import 'package:flutter_statemanagement/dialog/generic_dialog.dart';
import 'package:flutter_statemanagement/dialog/loading_screen.dart';
import 'package:flutter_statemanagement/model.dart';
import 'package:flutter_statemanagement/string.dart';
import 'package:flutter_statemanagement/views/iterable_list_view.dart';
import 'package:flutter_statemanagement/views/login_view.dart';

import 'api/note_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(
          title: "",
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(loginApi: LoginApi(), notesApi: NoteApi()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(homePage),
          ),
          body: BlocConsumer<AppBloc, AppState>(listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(context: context, text: pleaseWait);
            } else {
              LoadingScreen.instance().hide();
              final loginError = appState.loginError;
              if (loginError != null) {
                showGenericDialog(
                    context: context,
                    title: loginErrorDialogTitle,
                    content: loginErrorDialogContent,
                    optionBuilder: () => {ok: true});
              }
              if (appState.isLoading == false &&
                  appState.loginError == null &&
                  appState.loginHandle == const LoginHandle.fooBar() &&
                  appState.fetchedNotes == null) {
                context.read<AppBloc>().add(const LoadNotesAction());
              }
            }
          }, builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(onLoginTapped: (email, password) {
                context
                    .read<AppBloc>()
                    .add(LoginAction(email: email, password: password));
              });
            } else {
              return notes.toListView();
            }
          })),
    );
  }
}
