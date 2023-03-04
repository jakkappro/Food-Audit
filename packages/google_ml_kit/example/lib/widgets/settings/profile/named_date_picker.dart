import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NamedDatePicker extends StatefulWidget {
  NamedDatePicker({
    Key? key,
    required this.label,
    required this.value,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  DateTime value;
  final Future<void> Function(DateTime value) onChanged;
  String text;

  @override
  _NamedDatePickerState createState() => _NamedDatePickerState();
}

class _NamedDatePickerState extends State<NamedDatePicker> {
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
                  widget.label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    children: [
                      TextField(
                        enabled: true,
                        decoration: InputDecoration(
                          hintText: widget.text,
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final dateOfBirth = await showDatePicker(
                            context: context,
                            initialDate: widget.value,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (context, child) => child!,
                          );
                          if (dateOfBirth != null) {
                            setState(() {
                              widget.value = dateOfBirth;
                              widget.text =
                                  DateFormat('dd.MM.yyyy').format(widget.value);
                            });
                            await widget.onChanged(dateOfBirth);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
