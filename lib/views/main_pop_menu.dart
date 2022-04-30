import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_event.dart';
import 'package:flutter_statemanagement/dialog/delete_account_dialog.dart';
import 'package:flutter_statemanagement/dialog/logout_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopUpMenuButton extends StatelessWidget {
  const MainPopUpMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          )
        ];
      },
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogoutDialog(context);
            if (shouldLogOut) {
              context.read<AppBloc>().add(const AppEventLogout());
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              context.read<AppBloc>().add(const AppEventDeletAccount());
            }
            break;
        }
      },
    );
  }
}
