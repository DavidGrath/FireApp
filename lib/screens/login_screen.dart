import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './home_screen.dart';
import './signup_screen.dart';

class LoginScreen extends StatefulWidget {
  // var formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var signingIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: <Widget>[
          GestureDetector(
            child: Text("Sign Up"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return SignUpScreen();
              }));
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: (signingIn)
                          ? CircularProgressIndicator()
                          : Text("Log In"),
                      onPressed: () async {
                        setState(() {
                          signingIn = true;
                        });
                        await login(
                            emailController.text, passwordController.text);
                        setState(() {
                          signingIn = false;
                        });
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                      },
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  Future login(String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
