// ignore_for_file: deprecated_member_use

import 'package:Face_recognition/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(brightness: Brightness.light),
      home: _auth.currentUser == null ? SignIn() : MyHomePage(),
      title: "Face Recognition",
      debugShowCheckedModeBanner: false,
    );
  }
}
