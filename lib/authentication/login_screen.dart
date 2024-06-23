import 'package:capstone_project_carpool/authentication/signup_screen.dart';
import 'package:capstone_project_carpool/methods/common_methods.dart';
import 'package:capstone_project_carpool/pages/home_page.dart';
import 'package:capstone_project_carpool/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global/global_var.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation()
  {
    if (!emailTextEditingController.text.contains("@"))
    {
      cMethods.displaySnackBar("Please enter a valid email.", context);
    }
    else if (passwordTextEditingController.text.trim().length < 5)
    {
      cMethods.displaySnackBar("Password must be at least 6 or more characters.", context);
    }
    else
    {
      signInUser();
    }
  }

  signInUser() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => LoadingDialog(messageText: "Logging in..."),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);


    if(userFirebase != null)
      {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
        usersRef.once().then((snap)
        {
          if(snap.snapshot.value != null)
            {
              if((snap.snapshot.value as Map)["blockStatus"] == "no")
                {
                  userName = (snap.snapshot.value as Map)["firstName"];
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
                } else {
                FirebaseAuth.instance.signOut();
                cMethods.displaySnackBar("Client account is blocked, Contact Admin.", context);
              }
            } else
          {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Client account does not exist.", context);
          }
        });
      }
  }

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

              const SizedBox(height: 32,),

              const Text(
                "CLIENT LOGIN",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Text Fields
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [

                    // Email
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 22,),

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

                    const SizedBox(height: 50,),

                    ElevatedButton(
                      onPressed: ()
                      {
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      ),
                      child: const Text(
                          "LOGIN"
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              TextButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Colors.grey,

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
