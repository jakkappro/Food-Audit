import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../helpers/data_helpers.dart';
import '../../services/authentication_service.dart';
import '../../widgets/authentication/forget_password_slidingup.dart';
import '../../widgets/authentication/input_field.dart';
import '../../widgets/shared/button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _panelController = PanelController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        panel: ForgetPasswordSlidingUp(
          panelController: _panelController,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height > 900 ? height : 900,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: height * 0.09,
              top: height * 0.01,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(40, 48, 70, 1),
                  Color.fromRGBO(60, 78, 104, 1),
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
                    InputField(
                      hintText: 'johndoe@gmail.com',
                      isPassword: false,
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                      hintText: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                    ),
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
                    Button(
                      'Login',
                      Colors.white,
                      Colors.black,
                      double.infinity,
                      60,
                      15,
                      FontWeight.bold,
                      _logIn,
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

  Future<void> _logIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final logged = await login(email, password);

    switch (logged) {
      case LoginStatus.success:
        await loadData();
        await Navigator.pushReplacementNamed(context, '/home');
        break;
      case LoginStatus.emailNotVerified:
        await Navigator.pushReplacementNamed(context, '/verify-email');
        break;
      case LoginStatus.failed:
        _resetOnFail();
        break;
    }
  }

  void _resetOnFail() {
    _emailController.clear();
    _passwordController.clear();
    setState(() {});
  }
}
