import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _sendAnotherEmail();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      await _checkVerificationEmail();
    });
  }

  Future<void> _checkVerificationEmail() async {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.reload();
      if (user.emailVerified) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else if (user != null && user.emailVerified) {
      _timer.cancel();
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _sendAnotherEmail() async {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Please verify your email', style: TextStyle(fontSize: 30)),
      SizedBox(height: 25),
      Icon(Icons.email_rounded, size: 100),
    ])));
  }
}
