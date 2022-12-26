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
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: shouldShake
                      ? BorderSide(color: Colors.red)
                      : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: shouldShake
                      ? controller.text != ''
                          ? BorderSide.none
                          : BorderSide(color: Colors.red)
                      : BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: hitText),
          ),
        );
      });
}
