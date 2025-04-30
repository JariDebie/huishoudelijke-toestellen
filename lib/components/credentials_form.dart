import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/main/main_route.dart';

class CredentialsForm extends StatefulWidget {
  final String successText;
  final bool Function(String username, String password) onSuccessPress;

  const CredentialsForm({
    super.key,
    required this.successText,
    required this.onSuccessPress,
  });

  @override
  State<CredentialsForm> createState() => _CredentialsFormState();
}

class _CredentialsFormState extends State<CredentialsForm> {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          bool result = widget.onSuccessPress(_email!, _password!);
                          if (result) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainRoute()));
                          } else {
                            // error message
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.indigo),
                        foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                      ),
                      child: Text(widget.successText),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.red.shade200),
                        foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
