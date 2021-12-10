import 'package:Face_recognition/Screens/addfacescreen.dart';
import 'package:Face_recognition/Screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminContent extends StatefulWidget {
  @override
  _AdminContentState createState() => _AdminContentState();
}

class _AdminContentState extends State<AdminContent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Content'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'addface') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAddFaceScreen(),
                    ));
              } else if (value == 'logout') {
                _auth.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'addface',
                child: Text('Add Face'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'N A M E S',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: 100,
                    child: StreamBuilder(
                      stream: _firestore
                          .collection('allfaces')
                          .doc(_auth.currentUser.uid)
                          .collection('faces')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginUserFaceContent(
                                        name: snapshot.data.docs[index]
                                            .data()['name'],
                                        id: snapshot.data.docs[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "• " +
                                      snapshot.data.docs[index].data()['name'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'F A C E S',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: 100,
                    child: StreamBuilder(
                      stream: _firestore
                          .collection('allfaces')
                          .doc(_auth.currentUser.uid)
                          .collection('faces')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                snapshot.data.docs[index].data()['name'],
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'A P P L E T',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: 100,
                    child: StreamBuilder(
                      stream: _firestore
                          .collection('allfaces')
                          .doc(_auth.currentUser.uid)
                          .collection('faces')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                snapshot.data.docs[index].data()['name'],
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginUserFaceContent extends StatelessWidget {
  LoginUserFaceContent({this.name, this.id});

  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Center(
          child: Column(
            children: [
              Text(name, style: TextStyle(fontSize: 20)),
              Text(id),
            ],
          ),
        ),
      ),
    );
  }
}
