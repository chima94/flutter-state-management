import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_statemanagement/api/login_api.dart';
import 'package:flutter_statemanagement/api/note_api.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_start.dart';
import 'package:flutter_statemanagement/bloc/bloc_action.dart';
import 'package:flutter_statemanagement/model.dart';
import 'package:flutter_test/flutter_test.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3')
];

@immutable
class DummyNoteApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNoteApi(
      {required this.acceptedLoginHandle,
      required this.notesToReturnForAcceptedLoginHandle});

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }

  const DummyNoteApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi(
      {required this.acceptedEmail,
      required this.acceptedPassword,
      required this.handleToReturn});

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();
}

void main() {
  blocTest<AppBloc, AppState>(
    'Initail State of the bloc',
    build: () => AppBloc(
        loginApi: const DummyLoginApi.empty(),
        notesApi: const DummyNoteApi.empty(),
        acceptedLoginHandle: const LoginHandle(token: 'ABC')),
    verify: (appState) => expect(appState.state, const AppState.empty()),
  );

  blocTest<AppBloc, AppState>('Can we log in with correct credential',
      build: () => AppBloc(
          loginApi: const DummyLoginApi(
              acceptedEmail: 'bar@baz.com',
              acceptedPassword: 'foo',
              handleToReturn: LoginHandle(token: 'ABC')),
          notesApi: const DummyNoteApi.empty(),
          acceptedLoginHandle: const LoginHandle(token: 'ABC')),
      act: (appBloc) =>
          appBloc.add(const LoginAction(email: 'bar@baz.com', password: 'foo')),
      expect: () => [
            const AppState(
                isLoading: true,
                loginError: null,
                loginHandle: null,
                fetchedNotes: null),
            const AppState(
                isLoading: false,
                loginError: null,
                loginHandle: LoginHandle(token: 'ABC'),
                fetchedNotes: null),
          ]);

  blocTest<AppBloc, AppState>(
      'We shouldnt be able to login with invalid credential',
      build: () => AppBloc(
          loginApi: const DummyLoginApi(
              acceptedEmail: 'foo@baz.com',
              acceptedPassword: 'baz',
              handleToReturn: LoginHandle(token: 'ABC')),
          notesApi: const DummyNoteApi.empty(),
          acceptedLoginHandle: const LoginHandle(token: 'ABC')),
      act: (appBloc) =>
          appBloc.add(const LoginAction(email: 'bar@baz.com', password: 'foo')),
      expect: () => [
            const AppState(
                isLoading: true,
                loginError: null,
                loginHandle: null,
                fetchedNotes: null),
            const AppState(
                isLoading: false,
                loginError: LoginErrors.invalidHandle,
                loginHandle: null,
                fetchedNotes: null),
          ]);

  blocTest<AppBloc, AppState>('Load some note with valid credential',
      build: () => AppBloc(
          loginApi: const DummyLoginApi(
              acceptedEmail: 'foo@baz.com',
              acceptedPassword: 'baz',
              handleToReturn: LoginHandle(token: 'ABC')),
          notesApi: const DummyNoteApi(
              acceptedLoginHandle: LoginHandle(token: 'ABC'),
              notesToReturnForAcceptedLoginHandle: mockNotes),
          acceptedLoginHandle: const LoginHandle(token: 'ABC')),
      act: (appBloc) {
        appBloc.add(const LoginAction(email: 'foo@baz.com', password: 'baz'));
        appBloc.add(const LoadNotesAction());
      },
      expect: () => [
            const AppState(
                isLoading: true,
                loginError: null,
                loginHandle: null,
                fetchedNotes: null),
            const AppState(
                isLoading: false,
                loginError: null,
                loginHandle: LoginHandle(token: 'ABC'),
                fetchedNotes: null),
            const AppState(
                isLoading: true,
                loginError: null,
                loginHandle: LoginHandle(token: 'ABC'),
                fetchedNotes: null),
            const AppState(
                isLoading: false,
                loginError: null,
                loginHandle: LoginHandle(token: 'ABC'),
                fetchedNotes: mockNotes),
          ]);
}
