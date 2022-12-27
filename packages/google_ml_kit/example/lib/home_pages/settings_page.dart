import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Settings Page', style: TextStyle(fontSize: 40)),
      SizedBox(height: 25),
      ElevatedButton(
          onPressed: () {
            _auth.signOut();
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: Text('Sign Out')),
      Icon(Icons.camera_alt, size: 100),
    ])));
  }
}
