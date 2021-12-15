// import 'package:Face_recognition/Screens/addfacescreen.dart';
import 'package:Face_recognition/Screens/adminfacecontent.dart';
import 'package:Face_recognition/Screens/settingscreen.dart';
// import 'package:Face_recognition/Screens/signin.dart';
import 'package:Face_recognition/homescreen.dart';

import 'package:flutter/material.dart';

class AdminContent extends StatefulWidget {
  @override
  _AdminContentState createState() => _AdminContentState();
}

class _AdminContentState extends State<AdminContent> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          title: Text('Admin Panel'),
          // actions: [
          //   PopupMenuButton(
          //     onSelected: (value) {
          //       if (value == 'addface') {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => MyAddFaceScreen(),
          //             ));
          //       } else if (value == 'logout') {
          //         Navigator.pushReplacement(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => MyHomePage(),
          //             ));
          //       }
          //     },
          //     itemBuilder: (context) => [
          //       PopupMenuItem(
          //         value: 'addface',
          //         child: Text('Add Face'),
          //       ),
          //       PopupMenuItem(
          //         value: 'logout',
          //         child: Text('Logout'),
          //       ),
          //     ],
          //   ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAdminFaceContent(),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const ListTile(
                            title: Text('Faces'),
                            subtitle: Text('All the faces for attendance.'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: GestureDetector(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const ListTile(
                            title: Text('System Users'),
                            subtitle:
                                Text('system users to access admin panel.'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingScreen(),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const ListTile(
                            title: Text('Settings'),
                            subtitle: Text('Settings to configure the system.'),
                          ),
                        ),
                      ],
                    ),
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
