import 'package:Face_recognition/constants.dart';
import 'package:Face_recognition/widgets/button_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _erpUrl, _apiKey, _apiSecret;
  bool _isLoading = false;

  Future<void> _submit() async {
    // implement the signUp method in cloud firestore
    // and then use the signUp method to create a new user
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        _firestore.collection('SettingsKey').add({
          'uid': _auth.currentUser.uid,
          'SowaanERP': _erpUrl,
          'ApiKey': _apiKey,
          'ApiSecret': _apiSecret,
          'date': DateTime.now(),
        });
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0),
                    child: Container(
                      child: Text(
                        'Integration Settings',
                        style: TextStyle(
                          fontSize: 20,
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
                            keyboardType: TextInputType.url,
                            onSaved: (input) => _erpUrl = input,
                            autofocus: true,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'SowaanERP URL',
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(
                                  Icons.link,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.url,
                            onSaved: (input) => _apiKey = input,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Api Key',
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(
                                  Icons.api_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            onSaved: (input) => _apiSecret = input,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Api Secret',
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(
                                  Icons.vpn_key,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                          BottonWidgets(
                            onPressed: _submit,
                            text: 'Submit',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
