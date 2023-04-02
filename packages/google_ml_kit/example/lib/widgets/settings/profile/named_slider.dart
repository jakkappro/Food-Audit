import 'dart:math';

import 'package:event/event.dart';
import 'package:flutter/material.dart';

class NamedSlider extends StatefulWidget {
  NamedSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.divisions,
    required this.event,
  }) : super(key: key);

  final String label;
  double value;
  final Future<void> Function(String value) onChanged;
  final double min;
  final double max;
  final int divisions;
  final Event<Value<double>> event;

  @override
  _NamedSliderState createState() => _NamedSliderState();
}

class _NamedSliderState extends State<NamedSlider> {
  _NamedSliderState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.value.toString()} ${widget.label == 'Vaha' ? 'kg' : 'cm'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorColor: Theme.of(context).colorScheme.secondary,
                  valueIndicatorTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  label: widget.value.toString(),
                  value: widget.value,
                  min: widget.min,
                  max: widget.max,
                  divisions: widget.divisions,
                  onChanged: ((value) async {
                    await widget.onChanged(value.ceil().toString());
                    setState(() {
                      widget.event.broadcast(Value(value));
                      widget.value = value;
                    });
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
