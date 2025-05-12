import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final String successText;
  final Future<(bool, String)> Function(String username, String password, String displayName, String email)
      onSuccessPress;

  const RegisterForm({
    super.key,
    required this.successText,
    required this.onSuccessPress,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  String? _confirmPassword;
  String? _displayName;
  String? _email;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Username"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your desired username";
              }
              return null;
            },
            onSaved: (newValue) {
              _username = newValue;
            }
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Display Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your display name";
              }
              return null;
            },
            onSaved: (newValue) {
              _displayName = newValue;
            }
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              if (!RegExp(r'.+@.+\..+').hasMatch(value)) {
                return "Please enter a valid email address";
              }
              return null;
            },
            onSaved: (newValue) {
              _email = newValue;
            }
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              return null;
            },
            onSaved: (newValue) {
              _password = newValue;
            }
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Confirm Password"),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password again";
              }
              return null;
            },
            onSaved: (newValue) {
              _confirmPassword = newValue;
            }
          ),
          if (_errorMessage != null)
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (_password != _confirmPassword) {
                    setState(() {
                      _errorMessage = "Passwords do not match";
                    });
                    return;
                  }

                  (bool, String) result = await widget.onSuccessPress(
                    _username!,
                    _password!,
                    _displayName!,
                    _email!
                  );
                  if (!result.$1) {
                    setState(() {
                      _errorMessage = result.$2;
                    });
                    return;
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(widget.successText)
            ),
          )
        ],
      )
    );
  }
}
