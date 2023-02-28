import 'package:flutter/material.dart';

import '../../../models/settings_model.dart';

class SearchBarResult extends StatefulWidget {
  const SearchBarResult({Key? key, this.name}) : super(key: key);
  final String? name;
  @override
  _SearchBarResultState createState() => _SearchBarResultState(name: name);
}

class _SearchBarResultState extends State<SearchBarResult> {
  _SearchBarResultState({this.name});

  final SettingsModel settings = SettingsModel.instance;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name != null ? name! : 'Predvolený',
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              settings.selectedList = name ?? 'default';
              settings.saveToFirebase();
              setState(() {});
            },
            icon: const Icon(Icons.add),
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
