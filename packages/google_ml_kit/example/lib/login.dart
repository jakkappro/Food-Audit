import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.shortestSide;
    final height = MediaQuery.of(context).size.longestSide;

    return  Scaffold(
      body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: height * 0.12, top: height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Hello, \nWelcome Back', style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: width * 0.1,)),
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
                            image: AssetImage('assets/icons/google.png')
                          )
                        ),
                        SizedBox(width: 25),
                        TextButton(
                          onPressed: () => {},
                          child: Image(
                            width: 30,
                            image: AssetImage('assets/icons/facebook.png')
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 55,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email'
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password'
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0)
                      ),
                      child: Text('Forgot Password?', style: Theme.of(context).textTheme.bodyText1,),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: logIn,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Center(child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
                    ),
                    SizedBox(height: 15, width: width,),
                    TextButton(
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        fixedSize: Size(320, 48) 
                      ),
                      child: Text('Create account', style: Theme.of(context).textTheme.bodyText1)
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }

  Future<void> logIn() async {
    try {
    final result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      
    }
  }
}