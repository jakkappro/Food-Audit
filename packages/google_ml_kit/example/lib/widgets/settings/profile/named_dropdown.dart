import 'package:flutter/material.dart';

class NamedDropdown extends StatefulWidget {
  NamedDropdown({
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
  _NamedDropdownState createState() => _NamedDropdownState();
}

class _NamedDropdownState extends State<NamedDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pohlavie',
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
                        child: DropdownButton<String>(
                          value: widget.value,
                          isExpanded: false,
                          elevation: 3,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          dropdownColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          alignment: Alignment.center,
                          underline: Container(),
                          icon: Container(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          items: widget.items
                              .map(
                                (gender) => DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(
                                    gender[0].toUpperCase() +
                                        gender.substring(1).toLowerCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              widget.value = value!;
                            });
                            widget.onChanged(value!);
                          },
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
