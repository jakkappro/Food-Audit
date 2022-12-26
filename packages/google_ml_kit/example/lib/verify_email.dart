import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    _checkVerificationEmail();
  }

  Future<void> _checkVerificationEmail() async {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      auth.authStateChanges().listen((event) {
        if (event != null && event.emailVerified) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    } else if (user != null && user.emailVerified) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Please verify your email', style: TextStyle(fontSize: 40)),
      SizedBox(height: 25),
      Icon(Icons.email_rounded, size: 100),
    ])));
  }
}
