import 'package:flutter/material.dart';

class BorderlessButton extends StatelessWidget {
  const BorderlessButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.color = Colors.white,
    required this.label,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Icon icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        height: 60,
        child: ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Row(
              children: [
                Icon(
                  icon.icon,
                  color: color,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
