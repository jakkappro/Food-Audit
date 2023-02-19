import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'helpers/data_helpers.dart';
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
                left: 20, right: 20, bottom: height * 0.09, top: height * 0.01),
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
                    buildButton('Login', Colors.white, Colors.black,
                        double.infinity, 60, 15, FontWeight.bold, _logIn),
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
          child: buildButton(
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
          child: buildButton(
            'Cancel',
            Colors.transparent,
            Colors.black,
            double.infinity,
            50,
            15,
            FontWeight.bold,
            _panelController.close,
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
      _panelController.close();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _logIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        // login successful
        if (result.user!.emailVerified == false) {
          Navigator.pushReplacementNamed(context, '/verify-email');
        } else {
          await loadData();
          Navigator.pushReplacementNamed(context, '/home');
        }
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
