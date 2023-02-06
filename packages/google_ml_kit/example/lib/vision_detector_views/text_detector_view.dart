import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/aditives_model.dart';
import '../models/settings_model.dart';
import 'camera_view.dart';

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
  List<String> _aditives = [];
  bool foundLastComposition = false;
  final AditivesModel _aditivesModel = AditivesModel.instance;

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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 200,
                height: 60,
                child: Text(
                  _alergicOn.isNotEmpty
                      ? 'You are going to die'
                      : 'You are safe',
                  style: const TextStyle(
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
    bool foundComp = false;
    bool foundNutritions = false;
    final List<String> foundAlergens = [];
    final List<String> foundAditives = [];
    double tuky = -1.0;
    double sacharidy = -1.0;
    double cukry = -1.0;
    double blielkoviny = -1.0;
    double sol = -1.0;
    double energia = -1.0;
    double nasyteneTuky = -1.0;
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      for (final block in recognizedText.blocks) {
        final formatedText = block.text.toLowerCase();
        if (formatedText.contains('zloženie')) {
          _animation.reverse();
          foundComp = true;
          for (final alergenCategory in settings.allAlergens.entries) {
            if (settings.allergens.contains(alergenCategory.key)) {
              for (final alergen in alergenCategory.value) {
                if (formatedText.contains(alergen.toLowerCase())) {
                  foundAlergens.add(alergen);
                }
              }
            }
          }

          // aditives
          _aditivesModel.aditivs.forEach(
            (key, value) {
              if (formatedText.contains(key.toLowerCase())) {
                foundAditives.add(key);
              }
              for (final aditive in List<String>.from(value['names'])) {
                if (formatedText.contains(aditive.toLowerCase())) {
                  foundAditives.add(key);
                }
              }
            },
          );
        }
      }

      // nutritions
      // if (recognizedText.text.toLowerCase().contains('energia')) {
      //   foundNutritions = true;
      //   final regExp = RegExp(r'\d+');
      //   final matches = regExp.allMatches(recognizedText.text.toLowerCase());
      //   for (final match in matches) {
      //     final number = recognizedText.text.toLowerCase().substring(match.start, match.end);
      //     if (energia == -1.0) {
      //       energia = double.parse(number);
      //     } else if (tuky == -1.0) {
      //       tuky = double.parse(number);
      //     } else if (nasyteneTuky == -1.0) {
      //       nasyteneTuky = double.parse(number);
      //     } else if (cukry == -1.0) {
      //       cukry = double.parse(number);
      //     } else if (sacharidy == -1.0) {
      //       sacharidy = double.parse(number);
      //     } else if (blielkoviny == -1.0) {
      //       blielkoviny = double.parse(number);
      //     } else if (sol == -1.0) {
      //       sol = double.parse(number);
      //     }
      //   }
      //   foundNutritions = true;
      // }
    } else {
      _text = 'Recognized text:\n\n${recognizedText.text}';
      _customPaint = null;
    }

    await Future.delayed(const Duration(milliseconds: 30));

    _isBusy = false;

    if (!foundComp) {
      _retriesOfFindingComposition++;
    } else {
      _retriesOfFindingComposition = 0;
    }

    if (mounted) {
      setState(() {
        if (foundComp && !foundLastComposition) {
          _alergicOn = foundAlergens;
          _animation.reverse();
          _foundAnimation.forward();
          foundLastComposition = true;
          foundComposition = foundComp;
          _aditives = foundAditives;
        } else if (_retriesOfFindingComposition > 7) {
          _animation.forward();
          _foundAnimation.reverse();
          _alergicOn = [];
          foundLastComposition = false;
          foundComposition = foundComp;
          _aditives = foundAditives;
        }
      });
    }
  }
}
