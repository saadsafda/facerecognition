//  impliment the SignIn stateFull widget in firebase
//  and then use the SignIn method to create a new user

// ignore_for_file: missing_return, deprecated_member_use, unused_field
import 'package:Face_recognition/Screens/signup.dart';
import 'package:Face_recognition/homescreen.dart';
import 'package:Face_recognition/widgets/button_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        UserCredential authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        User user = authResult.user;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print("No User Found for that Email");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "No User Found for that Email",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          );
        } else if (e.code == 'wrong-password') {
          print("Wrong Password Provided by User");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Wrong Password Provided by User",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      print('error');
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
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
                        text: 'Sign In',
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
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
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              'Sign Up',
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
