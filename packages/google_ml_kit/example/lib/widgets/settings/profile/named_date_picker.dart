import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NamedDatePicker extends StatefulWidget {
  const NamedDatePicker({
    Key? key,
    required this.label,
    required this.value,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final DateTime value;
  final Future<void> Function(DateTime value) onChanged;
  final String text;

  @override
  _NamedDatePickerState createState() =>
      _NamedDatePickerState(label, value, onChanged, text);
}

class _NamedDatePickerState extends State<NamedDatePicker> {
  _NamedDatePickerState(
    this.label,
    this.value,
    this.onChanged,
    this.text,
  );

  String text;
  final String label;
  DateTime value;
  final Future<void> Function(DateTime value) onChanged;

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
                  style: const TextStyle(
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
                          hintText: text,
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final dateOfBirth = await showDatePicker(
                            context: context,
                            initialDate: value,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                  surface: Colors.black,
                                  onSurface: Colors.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.black, // button text color
                                  ),
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child!,
                            ),
                          );
                          if (dateOfBirth != null) {
                            setState(() {
                              value = dateOfBirth;
                              text = DateFormat('dd.MM.yyyy').format(value);
                            });
                            await onChanged(dateOfBirth);
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
