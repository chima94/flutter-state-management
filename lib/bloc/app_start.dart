import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_statemanagement/model.dart';
import 'package:collection/collection.dart';

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

  @override
  bool operator ==(covariant AppState other) {
    final otherPropertiesEqual = isLoading == other.isLoading &&
        loginHandle == other.loginHandle &&
        loginError == other.loginError;

    if (fetchedNotes == null && other.fetchedNotes == null) {
      return otherPropertiesEqual;
    } else {
      return otherPropertiesEqual &&
          (fetchedNotes?.isEqualTo(other.fetchedNotes) ?? true);
    }
  }

  @override
  int get hashCode =>
      Object.hash(isLoading, loginError, loginHandle, fetchedNotes);
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) =>
      const DeepCollectionEquality.unordered().equals(this, other);
}
