import 'dart:math';

import 'package:event/event.dart';
import 'package:flutter/material.dart';

class NamedSlider extends StatefulWidget {
  const NamedSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onSliderChanged,
  }) : super(key: key);

  final String label;
  final double value;
  final Future<void> Function(String value) onChanged;
  final double min;
  final double max;
  final int divisions;
  final Event<Value<double>> onSliderChanged;

  @override
  _NamedSliderState createState() => _NamedSliderState(
        label,
        value,
        onChanged,
        min,
        max,
        divisions,
        onSliderChanged,
      );
}

class _NamedSliderState extends State<NamedSlider> {
  _NamedSliderState(
    this.label,
    this.value,
    this.onChanged,
    this.min,
    this.max,
    this.divisions,
    this.event,
  );

  final String label;
  double value;
  final Future<void> Function(String value) onChanged;
  final double min;
  final double max;
  final int divisions;
  final Event<Value<double>> event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Slider(
                label: value.toString(),
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: ((value) async {
                  await onChanged(value.ceil().toString());

                  setState(() {
                    event.broadcast(Value(value));
                    this.value = value;
                  });
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
