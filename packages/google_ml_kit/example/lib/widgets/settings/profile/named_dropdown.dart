import 'package:flutter/material.dart';

class NamedDropDown extends StatefulWidget {
  const NamedDropDown({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  final String label;
  final String value;
  final Future<void> Function(String value) onChanged;
  final List<String> items;

  @override
  _NamedDropDownState createState() => _NamedDropDownState(
        label,
        value,
        onChanged,
        items,
      );
}

class _NamedDropDownState extends State<NamedDropDown> {
  _NamedDropDownState(
    this.label,
    this.value,
    this.onChanged,
    this.items,
  );

  final String label;
  String value;
  final Future<void> Function(String value) onChanged;
  final List<String> items;

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
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  'Pohlavie: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: DropdownButton<String>(
                    value: value,
                    dropdownColor: Colors.transparent,
                    elevation: 0,
                    items: items
                        .map((gender) => DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                  gender[0].toUpperCase() +
                                      gender.substring(1).toLowerCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  )),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        this.value = value!;
                      });
                      onChanged(value!);
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
