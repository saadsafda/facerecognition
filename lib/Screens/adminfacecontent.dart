// ignore_for_file: deprecated_member_use

import 'package:Face_recognition/Screens/addfacescreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAdminFaceContent extends StatefulWidget {
  @override
  _MyAdminFaceContentState createState() => _MyAdminFaceContentState();
}

class _MyAdminFaceContentState extends State<MyAdminFaceContent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _editname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text('Faces'),
          actions: [
            IconButton(
              icon: Icon(Icons.person_add_alt_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAddFaceScreen(),
                    ));
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
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
                      return Expanded(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data.docs[index].data()['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Delete'),
                                            content: Text(
                                                'Are you sure you want to delete this face?'),
                                            actions: [
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Delete'),
                                                onPressed: () {
                                                  _firestore
                                                      .collection('allfaces')
                                                      .doc(
                                                          _auth.currentUser.uid)
                                                      .collection('faces')
                                                      .doc(snapshot
                                                          .data.docs[index].id)
                                                      .delete();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Edit'),
                                            content: TextField(
                                              decoration: InputDecoration(
                                                labelText: snapshot
                                                    .data.docs[index]
                                                    .data()['name'],
                                              ),
                                              onChanged: (value) {
                                                _editname = value;

                                                // show the name in the textfield in database
                                              },
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Save'),
                                                onPressed: () {
                                                  _firestore
                                                      .collection('allfaces')
                                                      .doc(
                                                          _auth.currentUser.uid)
                                                      .collection('faces')
                                                      .doc(snapshot
                                                          .data.docs[index].id)
                                                      .update({
                                                    'name': _editname,
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
