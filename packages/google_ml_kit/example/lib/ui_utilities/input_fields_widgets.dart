import 'package:flutter/material.dart';

AnimatedBuilder createInputField(
    String hitText,
    bool isPassword,
    TextEditingController controller,
    bool shouldShake,
    AnimationController animationController,
    Tween<double> shakeTween) {
  return AnimatedBuilder(
    animation: animationController,
    builder: (context, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.fastLinearToSlowEaseIn,
        transform: Matrix4.translationValues(
            shouldShake ? shakeTween.evaluate(animationController) : 0, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
              alignLabelWithHint: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: !isPassword
                  ? const Text(
                      'Email',
                      style: TextStyle(
                        color: Color.fromRGBO(103, 117, 142, 1),
                        fontSize: 12,
                      ),
                    )
                  : const Text(
                      'Password',
                      style: TextStyle(
                        color: Color.fromRGBO(103, 117, 142, 1),
                        fontSize: 12,
                      ),
                    ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 25,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              hintText: hitText,
              hintStyle: const TextStyle(color: Colors.white)),
        ),
      );
    },
  );
}

ElevatedButton buildButton(
  String label,
  Color color,
  Color textColor,
  double width,
  double height,
  double fontSize,
  FontWeight fontWeight,
  void Function() onPressed, {
  Color? borderColor,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.all(18),
      fixedSize: Size(width, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: 1.5,
        ),
      ),
      backgroundColor: color,
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          fontWeight: fontWeight,
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    ),
  );
}
