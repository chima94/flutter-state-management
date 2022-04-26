import 'dart:ui';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_statemanagement/model.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState(
      {required this.isLoading,
      required this.loginError,
      required this.loginHandle,
      required this.fetchedNotes});

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandle': loginHandle,
        'fetchNotes': fetchedNotes
      }.toString();
}