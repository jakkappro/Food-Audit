import 'package:event/event.dart';
import 'package:flutter/material.dart';

import '../../../models/settings_model.dart';
import 'temperature_bar.dart';

class IndexDisplays extends StatelessWidget {
  IndexDisplays(this.bmi, this.bmr, this.bmiEvent, this.bmrEvent, {Key? key})
      : super(key: key);

  final double bmi;
  final double bmr;
  Color _weightColor = Colors.green;
  Color _caloriesColor = Colors.green;
  SettingsModel settings = SettingsModel.instance;
  final Event<Value<double>>? bmiEvent;
  final Event<Value<double>>? bmrEvent;

  void _setBmiColor() {
    if (bmi > 30) {
      _weightColor = Colors.red;
    } else if (bmi > 25) {
      _weightColor = Colors.orange;
    } else if (bmi > 18.5) {
      _weightColor = Colors.green;
    } else {
      _weightColor = Colors.blue;
    }
  }

  void _setBmrColor() {
    if (bmr > 2500) {
      _caloriesColor = Colors.red;
    } else if (bmr > 2000) {
      _caloriesColor = Colors.orange;
    } else if (bmr > 1500) {
      _caloriesColor = Colors.green;
    } else {
      _caloriesColor = Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the colors of the bars
    _setBmiColor();
    _setBmrColor();

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TemperatureBar(
            label: 'BMI',
            text: bmi.toStringAsFixed(2),
            value: bmi > 0 ? bmi / 40 : 0,
            color: _weightColor,
            event: bmiEvent,
          ),
          const SizedBox(width: 25),
          TemperatureBar(
            label: 'BMR',
            text: bmr.toStringAsFixed(2),
            value: bmr > 0 ? bmr / 4000 : 0,
            color: _caloriesColor,
            event: bmrEvent,
          ),
        ],
      ),
    );
  }
}
