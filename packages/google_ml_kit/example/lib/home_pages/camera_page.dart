import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
          Text('Camera Page', style: TextStyle(fontSize: 40)),
          SizedBox(height: 25),
          Icon(Icons.camera_alt, size: 100),
        ])));
  }
}