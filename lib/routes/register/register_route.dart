import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/register_form.dart';
import 'package:flutter_application_1/types/user.dart';

class RegisterRoute extends StatelessWidget {
  const RegisterRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            children: [
              RegisterForm(
                successText: "Register", 
                onSuccessPress: (username, password, displayName, email) async {
                  try {
                    CollectionReference users = FirebaseFirestore.instance
                        .collection("users")
                        .withConverter<User>(
                          fromFirestore: User.fromFirestore,
                          toFirestore: (User u, _) => u.toFirestore()
                        );
                    QuerySnapshot query = await users.where("username", isEqualTo: username).get();
                    if (query.docs.isNotEmpty) {
                      return (false, "Username already used");
                    }

                    await users.add(User(
                      username: username,
                      password: password,
                      displayName: displayName,
                      email: email
                    ));

                    return (true, "");
                  } catch (e) {
                    return (false, "An error occurred. Please try again later.\n$e");
                  }
                }
              )
            ]
          )
        )
      ),
    );
  }
}
