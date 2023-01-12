import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PanelController _panelController = PanelController();

  final _passwordController = TextEditingController();

  void singOut() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> security() async {
    final credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: _passwordController.text.trim());

    try {
      final result =
          await _auth.currentUser!.reauthenticateWithCredential(credential);
      if (result.user != null) {
        _panelController.close();
        Navigator.of(context).pushNamed('/security');
      }
    } on FirebaseAuthException catch (e) {}
  }

  void performance() {
    Navigator.of(context).pushNamed('/performance');
  }

  void profile() {
    Navigator.of(context).pushNamed('/profile');
  }

  void foodPreferences() {
    Navigator.of(context).pushNamed('/foodPreferences');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SlidingUpPanel(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                     Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildButton('Profile', profile, const Icon(Icons.person)),
                    const SizedBox(height: 20),
                    _buildButton('Performance', performance,
                        const Icon(Icons.trending_up)),
                    const SizedBox(height: 20),
                    _buildButton('Security', _panelController.open,
                        const Icon(Icons.lock)),
                    const SizedBox(height: 20),
                    _buildButton('Food Preferences', foodPreferences,
                        const Icon(Icons.fastfood)),
                    const SizedBox(height: 20),
                    _buildButton('Log Out', singOut, const Icon(Icons.logout),
                        color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
          isDraggable: false,
          panel: _buildSlidingUp(),
          minHeight: 0,
          maxHeight: 290,
          controller: _panelController,
          color: const Color.fromRGBO(66, 58, 76, 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
      ),
    );
  }

  Widget _buildSlidingUp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Center(
          child: Text('Verify your password',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              )),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            'Re-enter your password to access this settings page and to make changes',
            style: TextStyle(
              fontSize: 13,
              color: Color.fromRGBO(188, 188, 193, 1),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(56, 45, 62, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
            onPressed: security,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                )),
            child: const Center(
              child: Text(
                'Continue',
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
                backgroundColor: const Color.fromRGBO(56, 45, 62, 1),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                )),
            child: const Center(
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

  Widget _buildButton(String label, void Function() onPressed, Icon icon,
      {Color color = Colors.white}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            elevation: 0,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            children: [
              Icon(
                icon.icon,
                color: color,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
