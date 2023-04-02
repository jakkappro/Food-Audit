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
        SizedBox(
          height: 60,
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dátum narodenia',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
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
                                widget.text = DateFormat('dd.MM.yyyy')
                                    .format(widget.value);
                              });
                              await widget.onChanged(dateOfBirth);
                            }
                          },
                          child: Center(
                            child: Text(
                              DateFormat('dd.MM.yyyy').format(widget.value),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
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
