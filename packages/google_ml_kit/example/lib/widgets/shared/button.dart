import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
    this.label,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.onPressed, {
    Key? key,
    this.borderColor,
  }) : super(key: key);

  final String label;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback onPressed;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
