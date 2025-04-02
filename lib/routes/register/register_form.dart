import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                _password = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle login logic here, for now just redirect to /main or something
                      print('Email: $_email, Password: $_password');
                      Navigator.pushReplacementNamed(context, "/main");
                    }
                  },
                  child: const Text('Register'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/");
                  }, 
                  child: const Text("Cancel"),
                )
              ),
            ],),
          )
        ],
      ),
    );
  }
}
