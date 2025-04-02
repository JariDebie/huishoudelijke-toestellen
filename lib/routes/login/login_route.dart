import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/credentials_form.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: CredentialsForm(
          successText: "Login",
          onSuccessPress: (username, password) {
            return true;
          },
        ),
      ),
    );
  }
}