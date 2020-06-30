import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './login_screen.dart';
import './home_screen.dart';

class SignUpScreen extends StatefulWidget {
  // var formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  bool agreedWithTC = false;
  bool signingIn = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.blue, BlendMode.modulate),
              image: AssetImage(
                "images/man_smiling.jpg",
              ),
              fit: BoxFit.cover)),
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                      child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16.0),
                  )),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
              )
            ],
          ),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    color: Theme.of(context).primaryColor),
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 8.0, right: 8.0),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 26.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field must not be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0)),
                            filled: true,
                            fillColor: Colors.grey[800]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field must not be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Username",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0)),
                            filled: true,
                            fillColor: Colors.grey[800]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field must not be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0)),
                            filled: true,
                            fillColor: Colors.grey[800]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: confirmController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field must not be empty";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0)),
                            filled: true,
                            fillColor: Colors.grey[800]),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: agreedWithTC,
                          onChanged: (value) {
                            setState(() {
                              agreedWithTC = value;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                // style: TextStyle(fontSize: 12.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "I have read and agree with the "),
                                  TextSpan(
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                      text: "terms and conditions")
                                ]),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: (signingIn)
                                ? CircularProgressIndicator()
                                : Text("Sign Up"),
                            onPressed: agreedWithTC ? buttonPressed : null,
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<void> buttonPressed() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        signingIn = true;
      });
      await signUp(emailController.text, passwordController.text);
      setState(() {
        signingIn = false;
      });
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    }
  }

  Future<void> signUp(String email, String password) async {
    var auth = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    Firestore.instance.collection("user").document(auth.user.uid).setData(
        {"username": usernameController.text, "email": emailController.text});
  }
}
