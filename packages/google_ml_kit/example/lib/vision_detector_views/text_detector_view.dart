import 'package:flutter/material.dart';
import 'package:food_audit/vision_detector_views/painters/text_detector_painter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  List<String> _aditives = [];
  bool foundLastComposition = false;
  final AditivesModel _aditivesModel = AditivesModel.instance;
  late bool _detailOpened;

  final _panelController = PanelController();

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _detailOpened = false;
    _animation = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    _foundAnimation = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
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
      color: Colors.white,
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
          if (_aditives.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Text(
                  'Aditives: ${_aditives.join(', ')}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (foundComposition)
            Positioned(
              bottom: 100,
              child: Container(
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
          _animation.reverse();
          foundComp = true;

          // alergens
          for (final alergen in settings.allergicOn!) {
            if (formatedText.contains(alergen.toLowerCase())) {
              foundAlergens.add(alergen);
              textToPaint.add(alergen.toLowerCase());
            }
          }

          // aditives
          _aditivesModel.aditivs.forEach(
            (key, value) {
              if (formatedText.contains(key.toLowerCase())) {
                foundAditives.add(key);
                textToPaint.add(key);
              }
              for (final aditive in List<String>.from(value['names'])) {
                if (formatedText.contains(aditive.toLowerCase())) {
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

    await Future.delayed(const Duration(milliseconds: 20));

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
          _customPaint = null;
        }
      });
    }
  }

  Widget _buildPanel() {
    final additives = _aditives.map((e) => Additive(e, _aditivesModel.aditivsDescriptions[e]!)).toList();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: _aditives.length * 60 + 100,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
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
              const SizedBox(height: 20),
              if (_aditives.isNotEmpty)
                Text(
                  'Našli sme: ${_aditives.join(', ')} aditíva v tomto produkte.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ListView(
                children: <Widget>[
                  for (final additive in additives)
                    AdditiveItem(
                      additive: additive,
                    ),
                ],
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
      decoration: const BoxDecoration(
        color: Colors.white,
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
                backgroundColor: Colors.white,
                elevation: 0,
                shape: const CircleBorder(),
              ),
              child: const Center(
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 40,
                  color: Colors.black,
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.additive.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                widget.additive.description,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          const Divider(),
        ],
      ),
    );
  }
}

class Additive {
  final String name;
  final String description;

  Additive(this.name, this.description);
}
