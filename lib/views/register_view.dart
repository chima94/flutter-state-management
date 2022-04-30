import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_event.dart';
import 'package:flutter_statemanagement/extensions/if_debugging.dart';

class RegisterView extends HookWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'chimanwakis@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'chimanwakis94'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here...'),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  hintText: 'Enter your password here...'),
              obscureText: true,
              keyboardAppearance: Brightness.dark,
            ),
            TextButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  context
                      .read<AppBloc>()
                      .add(AppEventRegister(email: email, password: password));
                },
                child: const Text('Register')),
            TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppEventGoToLogin());
                },
                child: const Text('Already registered? Login!'))
          ],
        ),
      ),
    );
  }
}
