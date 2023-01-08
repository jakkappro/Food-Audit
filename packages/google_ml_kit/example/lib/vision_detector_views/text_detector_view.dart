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
    with SingleTickerProviderStateMixin {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  SettingsModel settings = SettingsModel.instance;
  final PanelController _panelController = PanelController();
  bool foundComposition = false;
  late AnimationController _animation;
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
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: _panelController,
      isDraggable: true,
      minHeight: 0,
      maxHeight: 350,
      color: const Color.fromRGBO(66, 58, 76, 1),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      panel: _buildPanel(),
      body: GestureDetector(
        onTap: () {
          if (foundComposition) {
            _panelController.open();
            _animation.reverse();
          }
        },
        child: Stack(
          children: [
            CameraView(
              title: 'Text Detector',
              customPaint: _customPaint,
              text: _text,
              onImage: (inputImage) {
                processImage(inputImage);
              },
            ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(66, 58, 76, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
          child: Column(children: [
            const Text(
              'Are you alergic to this?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_alergicOn.isNotEmpty)
              const Text(
                'Yes',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: _alergicOn.length,
              padding: EdgeInsets.only(top: 20.0),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.orange),
                    child: ListTile(
                      title: Text(
                        _alergicOn[index],
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (!_alergicOn.isNotEmpty)
              const Text(
                'No',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            const SizedBox(
              height: 5000,
            ),
          ]),
        ),
      ),
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

          final text = RecognizedText(text: 'Zloženie', blocks: [block]);
          final painter = TextRecognizerPainter(
              text,
              inputImage.inputImageData!.size,
              inputImage.inputImageData!.imageRotation);
          _customPaint = CustomPaint(painter: painter);
          found = true;
          continue;
        }

        // Nutritions
        if (block.text.toLowerCase().contains('výživové údaje')) {
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
          _animation.reverse();
        } else if (!_panelController.isPanelOpen &&
            _retriesOfFindingComposition > 5) {
          _animation.forward();
        }
        _alergicOn = foundAlergens;
        foundComposition = foundComp;
      });
    }
  }
}
