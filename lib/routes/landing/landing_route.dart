import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/login_form.dart';
import 'package:flutter_application_1/routes/main/main_route.dart';
import 'package:flutter_application_1/routes/register/register_route.dart';
import 'package:flutter_application_1/types/user.dart';

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
              LoginForm(
                successText: "Login",
                onSuccessPress: (username, password) async {
                  try {
                    CollectionReference users = FirebaseFirestore.instance
                        .collection("users");
                    QuerySnapshot query =
                        await users.where("email", isEqualTo: username).get();
                    if (query.docs.isEmpty) {
                      return (false, "Incorrect email or password");
                    }
                    if (query.docs[0].get("password") != password) {
                      return (false, "Incorrect email or password");
                    }
                    return (true, "");
                  } catch (e) {
                    return (
                      false,
                      "An error occurred. Please try again later.\n$e",
                    );
                  }
                },
                onSuccess: (username, password) async {
                  try {
                    CollectionReference users = FirebaseFirestore.instance
                        .collection("users")
                        .withConverter<User>(
                          fromFirestore: User.fromFirestore,
                          toFirestore: (User u, _) => u.toFirestore()
                        );
                    QuerySnapshot query =
                        await users.where("email", isEqualTo: username)
                            .where("password", isEqualTo: password).get();

                    if (query.docs.isEmpty) {
                      return "An error occurred. Please try again later.";
                    }

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainRoute(
                          user: query.docs[0].data() as User,
                        )),
                      );
                    }

                    return "";
                  } catch (e) {
                    return "An error occurred. Please try again later.\n$e";
                  }
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
                      MaterialPageRoute(
                        builder: (context) => const RegisterRoute(),
                      ),
                    );
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                    foregroundColor: WidgetStatePropertyAll<Color>(
                      Colors.white,
                    ),
                  ),
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
