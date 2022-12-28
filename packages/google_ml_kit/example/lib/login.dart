import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  final _panelController = PanelController();
  final _forgotPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

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
      body: SlidingUpPanel(
        controller: _panelController,
        isDraggable: false,
        minHeight: 0,
        maxHeight: 250,
        color: Color.fromRGBO(66, 58, 76, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        panel: _buildPanel(),
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
                      onPressed: _panelController.open,
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
      ),
    );
  }

  Widget _buildPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          child: Text("You'r email",
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              )),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromRGBO(56, 45, 62, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                  controller: _forgotPasswordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
            onPressed: _forgotPassword,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                )),
            child: Center(
              child: Text(
                'Send',
                style: TextStyle(
                    color: Color.fromRGBO(65, 55, 71, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: ElevatedButton(
            onPressed: _panelController.close,
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(56, 45, 62, 1),
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                )),
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _forgotPassword() async {
    final email = _forgotPasswordController.text.trim();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _panelController.close();
    } on FirebaseAuthException catch (error) {
      print('Error sending password reset email: $error');
    }
  }

  Future<void> _logIn() async {
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
