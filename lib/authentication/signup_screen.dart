import 'package:flutter/material.dart';
import 'package:capstone_project_carpool/authentication/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController middleNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController employeeNumberTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/slsulogo.png",
                ),
              ),

              const SizedBox(height: 32),

              const Center(
                child: Text(
                  "CLIENT SIGNUP",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name
                  TextField(
                    controller: firstNameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Middle Name
                  TextField(
                    controller: middleNameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Middle Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Last Name
                  TextField(
                    controller: lastNameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Employee Number
                  TextField(
                    controller: employeeNumberTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Employee Number",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Phone Number
                  TextField(
                    controller: phoneNumberTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Email
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Username
                  TextField(
                    controller: usernameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Password
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),

              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  ),
                  child: const Text("SIGN UP"),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
