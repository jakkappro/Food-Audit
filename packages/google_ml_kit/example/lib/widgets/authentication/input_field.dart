import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const InputField({
    Key? key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: !isPassword
            ? const Text(
                'Email',
                style: TextStyle(
                  fontSize: 12,
                ),
              )
            : const Text(
                'Password',
                style: TextStyle(
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
        hintText: hintText,
      ),
    );
  }
}
