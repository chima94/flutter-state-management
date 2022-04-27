import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_state.dart';
import 'package:flutter_statemanagement/bloc/bloc_event.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>('Initial State shoud be empty',
      build: () => AppBloc(urls: []),
      verify: (appBloc) => expect(appBloc.state, const AppState.empty()));

  blocTest<AppBloc, AppState>('Load valid data and compare the state',
      build: () => AppBloc(
          urls: [],
          urlPicker: (_) => '',
          urlLoader: (_) => Future.value(text1Data)),
      act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
      expect: () => [
            const AppState(isLoading: true, data: null, error: null),
            AppState(isLoading: false, data: text1Data, error: null)
          ]);

  blocTest<AppBloc, AppState>('Throw error in url loader and catch it',
      build: () => AppBloc(
          urls: [],
          urlPicker: (_) => '',
          urlLoader: (_) => Future.error(Errors.dummy)),
      act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
      expect: () => [
            const AppState(isLoading: true, data: null, error: null),
            const AppState(isLoading: false, data: null, error: Errors.dummy)
          ]);

  blocTest<AppBloc, AppState>('Test the ability to load more than one  Url',
      build: () => AppBloc(
          urls: [],
          urlPicker: (_) => '',
          urlLoader: (_) => Future.value(text2Data)),
      act: (appBloc) {
        appBloc.add(const LoadNextUrlEvent());
        appBloc.add(const LoadNextUrlEvent());
      },
      expect: () => [
            const AppState(isLoading: true, data: null, error: null),
            AppState(isLoading: false, data: text2Data, error: null),
            const AppState(isLoading: true, data: null, error: null),
            AppState(isLoading: false, data: text2Data, error: null)
          ]);
}
