import 'package:flutter/material.dart';

class AdminContent extends StatefulWidget {
  @override
  _AdminContentState createState() => _AdminContentState();
}

class _AdminContentState extends State<AdminContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Content'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Admin Content'),
          Text('Admin Content'),
          Text('Admin Content'),
        ],
      ),
    );
  }
}
