import 'package:Face_recognition/Screens/admincontent.dart';
import 'package:Face_recognition/widgets/button_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _email, _password;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
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
                        "Admin Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          onChanged: (value) {
                            _email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            hintText: "Admin Email",
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13),
                            suffixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          onChanged: (value) {
                            _password = value;
                          },
                          cursorColor: Theme.of(context).primaryColor,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Admin Password",
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.password,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13),
                            suffixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      BottonWidgets(
                        text: "Login",
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            final user = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _email, password: _password);
                            if (user != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminContent()));
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
