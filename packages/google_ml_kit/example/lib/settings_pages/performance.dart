import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/settings_model.dart';

enum ImageQuality {
  low,
  medium,
  high,
}

class PerformancePage extends StatefulWidget {
  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  final _auth = FirebaseAuth.instance;
  ImageQuality _imageQuality = ImageQuality.low;
  SettingsModel settings = SettingsModel.instance;

  @override
  void initState() {
    super.initState();
    _imageQuality = ImageQuality.values.firstWhere(
        (e) => e.toString() == settings.imageProcessingQuality,
        orElse: () => ImageQuality.low);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(56, 45, 62, 1),
        appBar: AppBar(
          title: const Text('Performance', style: TextStyle(fontSize: 30)),
          backgroundColor: const Color.fromRGBO(56, 45, 62, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(66, 58, 76, 1),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Image processing rate: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) async => await _changeFps(value),
                        decoration: InputDecoration(
                          hintText: 'FPS',
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(66, 58, 76, 1),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Image quality: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<ImageQuality>(
                    value: _imageQuality,
                    onChanged: (ImageQuality? newValue) {
                      setState(() {
                        _changeImageQuality(
                            newValue.toString().split('.').last);
                        _imageQuality = newValue!;
                      });
                    },
                    items: ImageQuality.values.map((ImageQuality option) {
                      return DropdownMenuItem<ImageQuality>(
                        value: option,
                        child:
                            Text(capitalize(option.toString().split('.').last)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      await settings.saveToFirebase();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _changeFps(String value) async {
    settings.imageProcessingFramerate = int.parse(value);
  }

  Future<void> _changeImageQuality(String value) async {
    settings.imageProcessingQuality = value.split('.').last;
  }

  String capitalize(String str) {
    return str.toLowerCase().substring(0, 1).toUpperCase() +
        str.toLowerCase().substring(1);
  }
}
