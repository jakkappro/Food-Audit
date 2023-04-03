import 'package:flutter/material.dart';

class AccesibilityPage extends StatefulWidget {
  const AccesibilityPage({Key? key}) : super(key: key);

  @override
  _AccesibilityPageState createState() => _AccesibilityPageState();
}

class _AccesibilityPageState extends State<AccesibilityPage> {
  Color selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appearance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Choose a new primary color for the app:'),
            Wrap(
              spacing: 8.0,
              children: Colors.primaries.map((color) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(width: 2.0, color: Colors.black)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
