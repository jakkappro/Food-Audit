import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/alergens_model.dart';
import 'camera_view.dart';
import 'painters/text_detector_painter.dart';

class TextRecognizerView extends StatefulWidget {
  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  AlergensModel? _alergensModel;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('userAlergens')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        _alergensModel =
            AlergensModel(alergens: List<String>.from(value.data()!['Milk']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      bool found = false;
      for (final block in recognizedText.blocks) {
        if (block.text.toLowerCase().contains('zloženie')) {
          if (_alergensModel != null) {
            for (final alergen in _alergensModel!.alergens) {
              if (block.text.toLowerCase().contains(alergen.toLowerCase())) {
                print('Found alergen: $alergen');
              }
            }
          }

          final text = RecognizedText(text: 'zlozenie', blocks: [block]);
          final painter = TextRecognizerPainter(
              text,
              inputImage.inputImageData!.size,
              inputImage.inputImageData!.imageRotation);
          _customPaint = CustomPaint(painter: painter);
          found = true;
          break;
        }
      }
      if (!found) {
        _text = 'Recognized text:\n\n${recognizedText.text}';
        _customPaint = null;
      }
    } else {
      _text = 'Recognized text:\n\n${recognizedText.text}';
      _customPaint = null;
    }

    await Future.delayed(Duration(milliseconds: 100));
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
