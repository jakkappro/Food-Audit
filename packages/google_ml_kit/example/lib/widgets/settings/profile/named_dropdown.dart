import 'package:flutter/material.dart';

class NamedDropDown extends StatefulWidget {
  NamedDropDown({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  final String label;
  String value;
  final Future<void> Function(String value) onChanged;
  final List<String> items;

  @override
  _NamedDropDownState createState() => _NamedDropDownState();
}

class _NamedDropDownState extends State<NamedDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: double.infinity,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Pohlavie: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: DropdownButton<String>(
                    value: widget.value,
                    isExpanded: true,
                    elevation: 0,
                    dropdownColor: Theme.of(context).colorScheme.surfaceVariant,
                    alignment: Alignment.center,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                    items: widget.items
                        .map((gender) => DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                gender[0].toUpperCase() +
                                    gender.substring(1).toLowerCase(),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.value = value!;
                      });
                      widget.onChanged(value!);
                    },
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
