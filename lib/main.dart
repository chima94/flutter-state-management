import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statemanagement/bloc/bottom_bloc.dart';
import 'package:flutter_statemanagement/bloc/top_bloc.dart';
import 'package:flutter_statemanagement/model/constants.dart';
import 'package:flutter_statemanagement/view/app_bloc_view.dart';

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
        home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TopBloc>(
            create: (_) => TopBloc(
              urls: images,
              waitingBeforeLoading: const Duration(seconds: 3),
            ),
          ),
          BlocProvider<BottomBloc>(
              create: (_) => BottomBloc(
                    urls: images,
                    waitingBeforeLoading: const Duration(seconds: 3),
                  )),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [AppBlocView<TopBloc>(), AppBlocView<BottomBloc>()],
        ),
      ),
    ));
  }
}
