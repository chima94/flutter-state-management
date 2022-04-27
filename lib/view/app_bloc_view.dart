import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_state.dart';
import 'package:flutter_statemanagement/bloc/bloc_event.dart';
import 'package:flutter_statemanagement/extension/start_with.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBlock(BuildContext context) {
    Stream.periodic(
            const Duration(seconds: 10), (_) => const LoadNextUrlEvent())
        .startWith(const LoadNextUrlEvent())
        .forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBlock(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(builder: (context, appState) {
        if (appState.error != null) {
          return const Text('An error occured, Try again in a moment');
        } else if (appState.data != null) {
          return Image.memory(
            appState.data!,
            fit: BoxFit.fitHeight,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
