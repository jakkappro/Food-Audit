import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../shared/button.dart';


class ForgetPasswordSlidingUp extends StatelessWidget {
  ForgetPasswordSlidingUp({Key? key, required this.panelController})
      : super(key: key);
  final _forgotPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final PanelController panelController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Center(
          child: Text(
            "You'r email",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                  controller: _forgotPasswordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
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
            'Send',
            const Color.fromRGBO(106, 140, 17, 1),
            const Color.fromRGBO(65, 55, 71, 1),
            double.infinity,
            55,
            15,
            FontWeight.bold,
            _forgotPassword,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: Button(
            'Cancel',
            Colors.transparent,
            Colors.black,
            double.infinity,
            50,
            15,
            FontWeight.bold,
            panelController.close,
            borderColor: Colors.grey,
          ),
        )
      ],
    );
  }

  Future<void> _forgotPassword() async {
    final email = _forgotPasswordController.text.trim();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      panelController.close();
      // ignore: empty_catches
    } catch (e) {}
  }
}
