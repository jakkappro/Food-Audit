import 'package:flutter/material.dart';

class AccesibilityPage extends StatefulWidget {
  const AccesibilityPage({Key? key}) : super(key: key);

  @override
  _AccesibilityPageState createState() => _AccesibilityPageState();
}

class _AccesibilityPageState extends State<AccesibilityPage> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accesibility'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Čítanie alergénov',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: (value) => setState(() {
                    this.value = value;
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
