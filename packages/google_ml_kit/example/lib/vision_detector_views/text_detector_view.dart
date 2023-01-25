import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../models/settings_model.dart';
import 'camera_view.dart';
import 'painters/text_detector_painter.dart';

class TextRecognizerView extends StatefulWidget {
  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView>
    with TickerProviderStateMixin {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  SettingsModel settings = SettingsModel.instance;
  bool foundComposition = false;
  late AnimationController _animation;
  late AnimationController _foundAnimation;
  int _retriesOfFindingComposition = 0;
  List<String> _alergicOn = [];
  Map<String, num> _nutritions = {};

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    _foundAnimation = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(
          title: 'Text Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: (inputImage) {
            processImage(inputImage);
          },
        ),
        if (!foundComposition)
          Positioned(
            top: MediaQuery.of(context).size.height / 3 - 60,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 200,
                height: 60,
                child: const Text(
                  "Move you'r camera to the product",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        if (foundComposition)
          Positioned(
            top: MediaQuery.of(context).size.height / 3 - 60,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: FadeTransition(
              opacity: _foundAnimation,
              child: const Text(
                'You are going to die from this product',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
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
    bool found = false;
    bool foundComp = false;
    bool foundNutritions = false;
    final List<String> foundAlergens = [];
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      for (final block in recognizedText.blocks) {
        // Composition
        if (block.text.toLowerCase().contains('zloženie')) {
          _animation.reverse();
          foundComp = true;
          for (final alergenCategory in settings.allAlergens.entries) {
            if (settings.allergens.contains(alergenCategory.key)) {
              for (final alergen in alergenCategory.value) {
                if (block.text.toLowerCase().contains(alergen.toLowerCase())) {
                  foundAlergens.add(alergen);
                }
              }
            }
          }

          // final text = RecognizedText(text: 'Zloženie', blocks: [block]);
          // final painter = TextRecognizerPainter(
          //     text,
          //     inputImage.inputImageData!.size,
          //     inputImage.inputImageData!.imageRotation);
          // _customPaint = CustomPaint(painter: painter);
          found = true;
          //continue;
        }

        // Nutritions
        if (block.text.toLowerCase().contains('výživové údaje')) {
          var energia = block.text
              .toLowerCase()[block.text.toLowerCase().indexOf('energia')];
          var tuky = block.text
              .toLowerCase()[block.text.toLowerCase().indexOf('tuky')];
          var sol =
              block.text.toLowerCase()[block.text.toLowerCase().indexOf('soľ')];
          var blielkoviny = block.text
              .toLowerCase()[block.text.toLowerCase().indexOf('blielkoviny')];
          var nmk = block.text
              .toLowerCase()[block.text.toLowerCase().indexOf('nasýtené')];
          var sacharidy = block.text
              .toLowerCase()[block.text.toLowerCase().indexOf('sacharidy')];

          foundNutritions = true;
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

    await Future.delayed(const Duration(milliseconds: 50));

    _isBusy = false;

    if (!foundComp) {
      _retriesOfFindingComposition++;
    } else {
      _retriesOfFindingComposition = 0;
    }

    if (mounted) {
      setState(() {
        if (foundComp) {
          _alergicOn = foundAlergens;
        } else if (_retriesOfFindingComposition > 5) {
          _animation.forward();
          _alergicOn = [];
        }
        foundComposition = foundComp;
      });
    }
  }
}
