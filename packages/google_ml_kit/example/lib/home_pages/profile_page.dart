import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
          Text('Profile page', style: TextStyle(fontSize: 40)),
          SizedBox(height: 25),
          Icon(Icons.camera_alt, size: 100),
        ])));
  }
}