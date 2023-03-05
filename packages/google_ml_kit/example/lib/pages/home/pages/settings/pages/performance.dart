import 'package:flutter/material.dart';

import '../../../../../constants/image_quality.dart';
import '../../../../../models/settings_model.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({Key? key}) : super(key: key);

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  ImageQuality _imageQuality = ImageQuality.low;
  SettingsModel settings = SettingsModel.instance;
  String selected = 'ImageQuality.low';

  @override
  void initState() {
    super.initState();
    _imageQuality = ImageQuality.values.firstWhere(
        (e) => e.toString().split('.').last == settings.imageProcessingQuality,
        orElse: () => ImageQuality.low);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Performance',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Image processing rate: ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
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
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
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
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Image quality: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<ImageQuality>(
                      value: _imageQuality,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (ImageQuality? newValue) {
                        if (newValue == null) return;
                        setState(
                          () {
                            _changeImageQuality(
                                newValue.toString().split('.').last);
                            _imageQuality = newValue;
                            selected = newValue.name;
                          },
                        );
                      },
                      items: ImageQuality.values.map(
                        (ImageQuality option) {
                          return DropdownMenuItem<ImageQuality>(
                            value: option,
                            child: Text(
                              capitalize(option.toString().split('.').last),
                            ),
                          );
                        },
                      ).toList(),
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
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                      ),
                      onPressed: () async {
                        await settings.saveToFirebase();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeFps(String value) async {
    settings.imageProcessingFramerate = int.parse(value);
  }

  Future<void> _changeImageQuality(String value) async {
    settings.imageProcessingQuality = value.split('.').last;
    await settings.saveToFirebase();
  }

  String capitalize(String str) {
    return str.toLowerCase().substring(0, 1).toUpperCase() +
        str.toLowerCase().substring(1);
  }
}
