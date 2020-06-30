import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(FireApp());

class FireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "FireApp",
        theme: ThemeData(brightness: Brightness.dark),
        home: FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, snapshot) {
              return (snapshot.data != null) ? HomeScreen() : LoginScreen();
            }));
  }
}
