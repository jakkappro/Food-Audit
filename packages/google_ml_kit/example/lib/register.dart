import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ui_utilities/input_fields_widgets.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController animationController;
  late Tween<double> shakeTween;

  bool allConditionsMet = false;
  bool shouldShake = false;
  bool shouldShakeEmail = false;
  bool shouldShakePassword = false;

  final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
      }
    });

    shakeTween = Tween<double>(begin: 0, end: 25);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.shortestSide;
    final height = MediaQuery.of(context).size.longestSide + 120;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: 1000,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(40, 48, 70, 1),
                Color.fromRGBO(60, 78, 104, 1)
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          padding: EdgeInsets.only(
              left: 20, right: 20, bottom: height * 0.1, top: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/icons/logoColored.png'),
                  width: 250,
                  height: 250,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  createInputField('First Name', false, _firstNameController,
                      shouldShake, animationController, shakeTween),
                  const SizedBox(
                    height: 20,
                  ),
                  createInputField('Last Name', false, _lastNameController,
                      shouldShake, animationController, shakeTween),
                  const SizedBox(
                    height: 20,
                  ),
                  createInputField('Email', false, _emailController,
                      shouldShakeEmail, animationController, shakeTween),
                  const SizedBox(
                    height: 20,
                  ),
                  createInputField('Password', true, _passwordController,
                      shouldShakePassword, animationController, shakeTween),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  buildButton('Register', Colors.white, Colors.black,
                      double.infinity, 55, 16, FontWeight.bold, _register),
                  SizedBox(
                    height: 15,
                    width: width,
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.pushReplacementNamed(context, '/login'),
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      fixedSize: const Size(320, 48),
                    ),
                    child: Text('Already have an account? Login',
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    bool shouldEmailShake = false;
    bool shouldPasswordShake = false;
    bool shouldShake = false;

    if (!_emailRegex.hasMatch(email)) {
      shouldEmailShake = true;
    }

    if (!_passwordRegex.hasMatch(password)) {
      shouldPasswordShake = true;
    }

    if (firstName == '' || lastName == '') {
      shouldShake = true;
    }

    if (shouldEmailShake || shouldPasswordShake || shouldShake) {
      setState(() {
        shouldShakeEmail = shouldEmailShake;
        shouldShakePassword = shouldPasswordShake;
        shouldShake = shouldShake;
      });
      return;
    }

    try {
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      result.user!.updateDisplayName('$firstName $lastName');
      Navigator.of(context).pushReplacementNamed('/verify-email');
    } on FirebaseAuthException catch (e) {
      // Get the error code
      final code = e.code;

      // Handle the error based on the code
      switch (code) {
        case 'weak-password':
          // The password is too weak
          break;
        case 'email-already-in-use':
          // The email is already in use by another user
          break;
        case 'invalid-email':
          // The email is invalid
          break;
        default:
          // An unknown error occurred
          break;
      }
    } catch (e) {
      // login failed
      log(123);
    }
  }
}
