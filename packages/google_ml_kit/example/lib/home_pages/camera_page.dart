import 'package:flutter/material.dart';

import '../vision_detector_views/text_detector_view.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TextRecognizerView(),
    );
  }
}
