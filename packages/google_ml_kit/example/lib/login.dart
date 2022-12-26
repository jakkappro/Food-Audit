import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ui_utilities/input_fields_widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController animationController;
  late Tween<double> shakeTween;

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

  bool shouldShake = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.shortestSide;
    final height = MediaQuery.of(context).size.longestSide;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.only(
              left: 20, right: 20, bottom: height * 0.12, top: height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Hello, \nWelcome Back',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: width * 0.1,
                      )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () => {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0.0),
                          ),
                          child: Image(
                              width: 30,
                              image: AssetImage('assets/icons/google.png'))),
                      SizedBox(width: 25),
                      TextButton(
                        onPressed: () => {},
                        child: Image(
                            width: 30,
                            image: AssetImage('assets/icons/facebook.png')),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  createInputField('Email', false, _emailController,
                      shouldShake, animationController, shakeTween),
                  SizedBox(
                    height: 20,
                  ),
                  createInputField('Password', true, _passwordController,
                      shouldShake, animationController, shakeTween),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    onPressed: () => {},
                    style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _logIn,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.white,
                    ),
                    child: Center(
                        child: Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                  ),
                  SizedBox(
                    height: 15,
                    width: width,
                  ),
                  TextButton(
                      onPressed: () => {
                            Navigator.pushReplacementNamed(
                                context, '/register'),
                          },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          fixedSize: Size(320, 48)),
                      child: Text('Create account',
                          style: Theme.of(context).textTheme.bodyText1)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _logIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        // login successful
        Navigator.pushReplacementNamed(context, '/verify-email');
      } else {
        // login failed
        triggerAnimationOnLoginFail();
      }
    } catch (e) {
      // login failed
      triggerAnimationOnLoginFail();
    }
  }

  void triggerAnimationOnLoginFail() {
    _emailController.clear();
    _passwordController.clear();
    shouldShake = true;
    setState(() {});
    animationController.forward();
  }
}
