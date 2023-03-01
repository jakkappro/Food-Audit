import 'package:flutter/material.dart';

import 'named_text_field.dart';

class Name extends StatelessWidget {
  const Name({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.onChangedFirstName,
    required this.onChangedLastName,
  }) : super(key: key);

  final String firstName;
  final String lastName;
  final Future<void> Function(String value) onChangedFirstName;
  final Future<void> Function(String value) onChangedLastName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NamedTextField(
          label: 'Meno',
          hintText: firstName,
          onSubmited: onChangedFirstName,
        ),
        const SizedBox(height: 20),
        NamedTextField(
          label: 'Priezvisko',
          hintText: lastName,
          onSubmited: onChangedLastName,
        ),
      ],
    );
  }
}
