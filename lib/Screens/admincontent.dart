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
                                  snapshot.data.docs[index].data()['name']),
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
                                  snapshot.data.docs[index].data()['name']),
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
