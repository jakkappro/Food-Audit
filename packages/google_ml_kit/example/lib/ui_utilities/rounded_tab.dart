import 'package:flutter/material.dart';

class RoundedTab extends StatelessWidget {
  final String text;

  const RoundedTab({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(text),
        ),
      ),
    );
  }
}
