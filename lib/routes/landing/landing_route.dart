import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/credentials_form.dart';
import 'package:flutter_application_1/routes/main/main_route.dart';
import 'package:flutter_application_1/routes/register/register_route.dart';

class LandingRoute extends StatelessWidget {
  const LandingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Appliances")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            children: [
              CredentialsForm(
                successText: "Login",
                onSuccessPress: (username, password) async {
                  try {
                    CollectionReference users = FirebaseFirestore.instance.collection("users");
                    QuerySnapshot query = await users.where("email", isEqualTo: username).get();
                    if (query.docs.isEmpty) return (false, "Incorrect email or password");
                    if (query.docs[0].get("password") != password) return (false, "Incorrect email or password");
                    return (true, "");
                  } catch (e) {
                    return (false, "An error occurred. Please try again later.\n$e");
                  }
                },
                onSuccess: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainRoute()),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text("Don't have an account?"),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegisterRoute())
                    );
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                    foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                  ),
                  child: const Text("Register")
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
