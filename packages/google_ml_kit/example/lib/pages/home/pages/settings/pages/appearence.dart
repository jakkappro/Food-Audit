import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../../models/settings_model.dart';
import '../../../../../widgets/settings/borderless_button.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  _AppearancePageState createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appearance'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BorderlessButton(
            label: 'Hlavna farba aplikácie',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor:
                              SettingsModel.instance.seedColor, //default color
                          onColorChanged: (Color color) async {
                            //on color picked
                            SettingsModel.instance.seedColor = color;
                            await SettingsModel.instance.saveToFirebase();
                          },
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('DONE'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); //dismiss the color picker
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.abc),
          ),
        ],
      ),
    );
  }
}
