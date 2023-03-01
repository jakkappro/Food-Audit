import 'package:event/event.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TemperatureBar extends StatefulWidget {
  TemperatureBar(
      {Key? key,
      required this.value,
      required this.color,
      required this.text,
      this.event,
      required this.label})
      : super(key: key);
  final String label;
  double value;
  Color color;
  final Event<Value<double>>? event;
  String text;

  @override
  State<TemperatureBar> createState() => _TemperatureBarState();
}

class _TemperatureBarState extends State<TemperatureBar> {
  @override
  void initState() {
    super.initState();
    widget.event?.subscribe((value) => setState(() {
          widget.value = value!.value;
          if (widget.label == 'BMI') {
            widget.text = (value.value * 40).toStringAsFixed(2);
          } else {
            widget.text = (value.value * 4000).toStringAsFixed(2);
          }
          _calculateColors();
        }));
  }

  void _calculateColors() {
    if (widget.value > 0.75) {
      widget.color = Colors.red;
    } else if (widget.value > 0.625) {
      widget.color = Colors.orange;
    } else if (widget.value > 0.4625) {
      widget.color = Colors.green;
    } else {
      widget.color = Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.rotate(
          angle: -1.5708,
          child: SizedBox(
            width: 100,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                value: widget.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          '${widget.label}: ${widget.text}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
