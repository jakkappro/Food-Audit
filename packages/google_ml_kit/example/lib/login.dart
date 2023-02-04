import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'main.dart';
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
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        panel: _buildPanel(),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: 900,
            padding: EdgeInsets.only(
                left: 20, right: 20, bottom: height * 0.09, top: height * 0.1),
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
                    createInputField(
                        'johndoe@gmail.com',
                        false,
                        _emailController,
                        shouldShake,
                        animationController,
                        shakeTween),
                    const SizedBox(
                      height: 20,
                    ),
                    createInputField('Password', true, _passwordController,
                        shouldShake, animationController, shakeTween),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: _panelController.open,
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color.fromRGBO(75, 89, 109, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.white,
                      ),
                      child: const Center(
                          child: Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                    ),
                    SizedBox(
                      height: 35,
                      width: width,
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.pushReplacementNamed(context, '/register'),
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        fixedSize: const Size(320, 40),
                      ),
                      child: Text('Create account',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signInAnonymously();
                        await loadDataAnonymously();
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        fixedSize: const Size(320, 48),
                      ),
                      child: Text(
                        'Continue as guest',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
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
          child: ElevatedButton(
            onPressed: _forgotPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(106, 140, 17, 1),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: const Center(
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: ElevatedButton(
            onPressed: _panelController.close,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: const BorderSide(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black,
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
