import 'package:flutter/material.dart';
import 'package:flutter_statemanagement/auth/auth_error.dart';
import 'package:flutter_statemanagement/dialog/generic_dialog.dart';

Future<void> showAuthErrorDialog(
    {required BuildContext context, required AuthError authError}) {
  return showGenericDialog<void>(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionBuilder: () => {'Ok': true});
}
