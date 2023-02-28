import 'package:flutter/material.dart';

import '../../services/authentication_service.dart';
import '../../widgets/authentication/input_field.dart';
import '../../widgets/shared/button.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                  InputField(
                    hintText: 'First Name',
                    isPassword: false,
                    controller: _firstNameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    hintText: 'Last Name',
                    isPassword: false,
                    controller: _lastNameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    hintText: 'Email',
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
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Button(
                    'Register',
                    Colors.white,
                    Colors.black,
                    double.infinity,
                    55,
                    16,
                    FontWeight.bold,
                    _register,
                  ),
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

    final result = await register(firstName, lastName, email, password);
    if (result == RegisterStatus.badEmail) {
      shouldEmailShake = true;
    } else if (result == RegisterStatus.badPassword) {
      shouldPasswordShake = true;
    } else if (result == RegisterStatus.badName) {
      shouldShake = true;
    }

    if (shouldEmailShake || shouldPasswordShake || shouldShake) {
      setState(() {});
      return;
    }
    if (result == RegisterStatus.success) {
      await Navigator.pushReplacementNamed(context, '/verify-email');
    }
  }
}
