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
          duration: Duration(milliseconds: 150),
          curve: Curves.fastLinearToSlowEaseIn,
          transform: Matrix4.translationValues(
              shouldShake ? shakeTween.evaluate(animationController) : 0, 0, 0),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                hintText: hitText,
                hintStyle: TextStyle(color: Colors.white)),
          ),
        );
      });
}
