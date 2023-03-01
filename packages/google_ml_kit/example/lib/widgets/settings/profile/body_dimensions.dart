import 'package:event/event.dart';
import 'package:flutter/material.dart';

import 'named_slider.dart';

class BodyDimensions extends StatefulWidget {
  const BodyDimensions({
    Key? key,
    required this.height,
    required this.weight,
    required this.onChangedHeight,
    required this.onChangedWeight,
    required this.heightEvent,
    required this.weightEvent,
  }) : super(key: key);

  final double height;
  final double weight;
  final Future<void> Function(String value) onChangedHeight;
  final Future<void> Function(String value) onChangedWeight;
  final Event<Value<double>> heightEvent;
  final Event<Value<double>> weightEvent;

  @override
  _BodyDimensionsState createState() => _BodyDimensionsState(
        height,
        weight,
        onChangedHeight,
        onChangedWeight,
        heightEvent,
        weightEvent,
      );
}

class _BodyDimensionsState extends State<BodyDimensions> {
  _BodyDimensionsState(this.height, this.weight, this.onChangedHeight,
      this.onChangedWeight, this.heightEvent, this.weightEvent);

  final double height;
  final double weight;
  final Future<void> Function(String value) onChangedHeight;
  final Future<void> Function(String value) onChangedWeight;
  final Event<Value<double>> heightEvent;
  final Event<Value<double>> weightEvent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NamedSlider(
          label: 'Vyska',
          value: height,
          onChanged: onChangedHeight,
          min: 50,
          max: 250,
          divisions: 200,
          onSliderChanged: heightEvent,
        ),
        const SizedBox(height: 20),
        NamedSlider(
          label: 'Vaha',
          value: weight,
          onChanged: onChangedWeight,
          min: 30,
          max: 200,
          divisions: 170,
          onSliderChanged: weightEvent,
        ),
      ],
    );
  }
}
