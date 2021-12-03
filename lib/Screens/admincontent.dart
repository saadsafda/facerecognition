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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'N A M E S',
            ),
            Text(
              'F A C E S',
            ),
            Text(
              'Admin Content',
            ),
          ],
        ),
      ),
    );
  }
}
