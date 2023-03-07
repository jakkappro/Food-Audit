// TODO: add flashlight support

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../helpers/challenges_helpers.dart';
import '../../helpers/data_helpers.dart';
import '../../models/aditives_model.dart';
import '../../models/settings_model.dart';
import 'camera_view.dart';
import 'painters/text_detector_painter.dart';

class TextRecognizerView extends StatefulWidget {
  const TextRecognizerView({Key? key}) : super(key: key);

  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView>
    with TickerProviderStateMixin {
  final flutterTts = FlutterTts();

  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  final settings = SettingsModel.instance;
  bool foundComposition = false;
  late AnimationController _animation;
  late AnimationController _foundAnimation;
  int _retriesOfFindingComposition = 0;
  List<String> _alergicOn = [];
  List<String> _aditives = [];
  bool foundLastComposition = false;
  final AditivesModel _aditivesModel = AditivesModel.instance;
  late bool _detailOpened;
  bool? _scannedToday;
  bool speaking = false;

  final _panelController = PanelController();

  void _speak(String text) async {
    if (!speaking) {
      speaking = true;
      await flutterTts.speak(text);
      speaking = false;
    }
  }

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('sk-SK');
    flutterTts.setPitch(1);
    _detailOpened = false;
    _animation = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    _foundAnimation = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    if (_scannedToday == null) {
      getChallengesDataFromFirebase(FirebaseAuth.instance.currentUser!)
          .then((value) {
        setState(() {
          _scannedToday = value['scan'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: _buildPanel(),
      controller: _panelController,
      isDraggable: false,
      minHeight: 0,
      maxHeight: (MediaQuery.of(context).size.height / 3) * 2,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
      backdropColor: Colors.grey,
      backdropEnabled: true,
      backdropOpacity: 0.8,
      backdropTapClosesPanel: true,
      color: Theme.of(context).colorScheme.surfaceVariant,
      onPanelClosed: () {
        setState(() {
          _detailOpened = false;
        });
      },
      onPanelOpened: () {
        setState(() {
          _detailOpened = true;
        });
      },
      body: Stack(
        children: [
          CameraView(
            title: 'Text Detector',
            customPaint: _customPaint,
            text: _text,
            onImage: (inputImage) {
              processImage(inputImage);
            },
          ),
          if (!foundComposition && _aditives.isEmpty)
            Positioned(
              top: 10,
              left: MediaQuery.of(context).size.width / 2 - 150,
              child: FadeTransition(
                opacity: _animation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 300,
                  height: 40,
                  child: Center(
                    child: Text(
                      'Namier kameru na zloženie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          if (foundComposition)
            Positioned(
              top: 10,
              left: MediaQuery.of(context).size.width / 2 - 150,
              child: FadeTransition(
                opacity: _foundAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 300,
                  height: 40,
                  child: Text(
                    _alergicOn.isNotEmpty
                        ? 'Ste alergický na: ${_alergicOn.join(', ')}'
                        : 'Nie ste alergický na žiadne zložky',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          if (_aditives.isNotEmpty)
            Positioned(
              top: 10,
              left: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: Text(
                  'Aditíva: ${_aditives.join(', ')}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (foundComposition)
            Positioned(
              bottom: 100,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Center(
                  child: _buildCollapsed(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_detailOpened) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    bool foundComp = false;
    final List<String> foundAlergens = [];
    final List<String> foundAditives = [];
    final List<String> textToPaint = [];
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      for (final block in recognizedText.blocks) {
        final formatedText = block.text.toLowerCase();
        if (formatedText.contains('zloženie')) {
          if (_scannedToday != null && _scannedToday == false) {
            await updateScanChallenge();
            setState(() {
              _scannedToday = true;
            });
          }
          if (settings.challenges['firstScan'] == false) {
            settings.challenges['firstScan'] = true;
            settings.saveToFirebase();
          }
          _animation.reverse();
          foundComp = true;

          // alergens
          for (final alergen in settings.allergicOn!) {
            if (formatedText.contains(alergen.toLowerCase()) &&
                !foundAlergens.contains(alergen)) {
              foundAlergens.add(alergen);
              textToPaint.add(alergen.toLowerCase());
            }
          }

          // aditives
          _aditivesModel.aditivs.forEach(
            (key, value) {
              if (formatedText.contains(key.toLowerCase()) &&
                  !foundAditives.contains(key)) {
                foundAditives.add(key);
                textToPaint.add(key);
              }
              for (final aditive in List<String>.from(value['names'])) {
                if (formatedText.contains(aditive.toLowerCase()) &&
                    !foundAditives.contains(key)) {
                  foundAditives.add(key);
                  textToPaint.add(aditive.toLowerCase());
                }
              }
            },
          );
        }
      }
      if (textToPaint.isNotEmpty) {
        final painter = TextRecognizerPainter(
            recognizedText,
            inputImage.inputImageData!.size,
            inputImage.inputImageData!.imageRotation,
            textToPaint);
        _customPaint = CustomPaint(painter: painter);
      }
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
          _speak(
              'Alergický na ${_alergicOn.join(', ')}. A na aditíva: ${_aditives.join(', ')}.');
        } else if (_retriesOfFindingComposition > 7) {
          _animation.forward();
          _foundAnimation.reverse();
          _alergicOn = [];
          foundLastComposition = false;
          foundComposition = foundComp;
          _aditives = foundAditives;
          _customPaint = null;
        }
      });
    }
  }

  Widget _buildPanel() {
    final additives = _aditives
        .map(
          (e) => Additive(e, AditivesModel.instance.aditivs[e]!['description']),
        ) //_aditivesModel.aditivsDescriptions[e]!
        .toList();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      width: 300,
      height: 300,
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: (_aditives.length * 60) + 200 + (_alergicOn.length * 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50 + _alergicOn.length * 10,
                child: Text(
                  _alergicOn.isNotEmpty
                      ? 'Našli sme: "${_alergicOn.join(', ')}" v tomto produkte.'
                      : 'Nie ste alergický na tento produkt.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              if (_aditives.isNotEmpty)
                Text(
                  'Našli sme: ${_aditives.join(', ')} aditíva v tomto produkte.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              if (_aditives.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: _aditives.length * 80,
                  child: ListView(
                    children: <Widget>[
                      for (final additive in additives)
                        SizedBox(
                          width: double.infinity,
                          height: 140,
                          child: AdditiveItem(
                            additive: additive,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsed() {
    if (!foundComposition) {
      return Container();
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _panelController.open();
                setState(() {
                  _detailOpened = true;
                });
              },
              
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 40,
                    color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdditiveItem extends StatefulWidget {
  final Additive additive;

  const AdditiveItem({Key? key, required this.additive}) : super(key: key);

  @override
  _AdditiveItemState createState() => _AdditiveItemState();
}

class _AdditiveItemState extends State<AdditiveItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: SizedBox(
        width: double.infinity,
        height: 60 + (isExpanded ? 80 : 0),
        child: Column(
          children: [
            if (isExpanded)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.additive.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            if (!isExpanded)
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 5),
                child: Text(
                  widget.additive.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            if (isExpanded)
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(
                  widget.additive.description.length > 120
                      ? '${widget.additive.description.substring(0, 120)}...'
                      : widget.additive.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class Additive {
  final String name;
  final String description;

  Additive(this.name, this.description);
}
