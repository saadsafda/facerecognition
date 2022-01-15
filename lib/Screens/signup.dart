//  impliment the signUp stateFull widget in firebase
//  and then use the signUp method to create a new user

// ignore_for_file: missing_return, deprecated_member_use

import 'package:Face_recognition/Screens/signin.dart';
import 'package:Face_recognition/homescreen.dart';
import 'package:Face_recognition/widgets/button_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        UserCredential authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        User user = authResult.user;
        if (user != null) {
          _firestore.collection('users').add({
            'uid': user.uid,
            'name': _name,
            'email': _email,
            'password': _password,
            'date': DateTime.now(),
          });
          _firestore
              .collection('SettingsKey')
              .doc(user.uid)
              .collection('settings')
              .doc('settingId')
              .set({
            'uid': user.uid,
            'SowaanERP': 'SowaanERP URL',
            'ApiKey': 'Api Key',
            'ApiSecret': 'Api Secret',
            'date': DateTime.now(),
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("Password Provided is too Weak");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          print("Account Already exists");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3383CD),
                      Color(0xFF11249F),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (input) {
                          if (input.length < 3) {
                            return 'Your Name needs to be at least 3 characters';
                          } else if (input.isEmpty) {
                            return 'Please type a Name';
                          }
                        },
                        onSaved: (input) => _name = input,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your Name',
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please type an email';
                          }
                        },
                        onSaved: (input) => _email = input,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        validator: (input) {
                          if (input.length < 6) {
                            return 'Your password needs to be at least 6 characters';
                          } else if (input.isEmpty) {
                            return 'Please type a password';
                          }
                        },
                        onSaved: (input) => _password = input,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Password',
                        ),
                        obscureText: true,
                      ),
                      BottonWidgets(
                        onPressed: _submit,
                        text: 'Sign Up',
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
