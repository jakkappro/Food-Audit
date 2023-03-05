import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../shared/button.dart';

class ConfirmPasswordSlidingUp extends StatelessWidget {
  const ConfirmPasswordSlidingUp({
    Key? key,
    required this.panelController,
    required this.passwordController,
    required this.onConfirm,
  }) : super(key: key);
  final PanelController panelController;
  final TextEditingController passwordController;
  final VoidCallback onConfirm;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Center(
          child: Text(
            'Verify your password',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            'Re-enter your password to access this settings page and to make changes',
            style: TextStyle(
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Button(
            'Confirm',
            const Color.fromRGBO(106, 140, 17, 1),
            const Color.fromRGBO(65, 55, 71, 1),
            double.infinity,
            55,
            18,
            FontWeight.bold,
            onConfirm,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: Button(
            'Cancel',
            const Color.fromRGBO(106, 140, 17, 1),
            const Color.fromRGBO(65, 55, 71, 1),
            double.infinity,
            40,
            14,
            FontWeight.bold,
            panelController.close,
          ),
        )
      ],
    );
  }
}
