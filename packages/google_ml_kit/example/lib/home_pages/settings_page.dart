import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../models/settings_model.dart';
import '../settings_pages/profile.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PanelController _panelController = PanelController();
  SettingsModel settings = SettingsModel.instance;

  final Map<String, List<Container>> _allergenIcons = {
    'Arašidy': [
      Container(
        child: Image.asset('assets/allergens/peanut.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/peanut-free.png'),
      ),
    ],
    'Horčica': [
      Container(
        child: Image.asset('assets/allergens/mustard.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/mustard.png'),
      ),
    ],
    'Mlieko': [
      Container(
        child: Image.asset('assets/allergens/milk.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/dairy-free.png'),
      ),
    ],
    'Morské plody': [
      Container(
        child: Image.asset('assets/allergens/shellfish.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/no-seafood.png'),
      ),
    ],
    'Orechy': [
      Container(
        child: Image.asset('assets/allergens/walnut.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/nut-free.png'),
      ),
    ],
    'Pšenica': [
      Container(
        child: Image.asset('assets/allergens/gluten.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/gluten-free.png'),
      ),
    ],
    'Ryby': [
      Container(
        child: Image.asset('assets/allergens/fish.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/no-fish.png'),
      ),
    ],
    'Sezam': [
      Container(
        child: Image.asset('assets/allergens/sesame.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/sesame.png'),
      ),
    ],
    'Sója': [
      Container(
        child: Image.asset('assets/allergens/soybean.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/soy-free.png'),
      ),
    ],
    'Vajcia': [
      Container(
        child: Image.asset('assets/allergens/egg.png'),
      ),
      Container(
        child: Image.asset('assets/allergens/egg-free.png'),
      ),
    ]
  };

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlidingUpPanel(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(40, 48, 70, 1),
                  Color.fromRGBO(60, 78, 104, 1)
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            height: 1700,
            width: double.infinity,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 724,
                  child: ProfilePage(),
                ),
                const SizedBox(height: 20),
                Container(
                  color: Color.fromRGBO(105, 140, 17, 1),
                  child: Row(
                    children: const [
                      SizedBox(width: 20),
                      Text(
                        'Allergens:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color.fromRGBO(105, 140, 17, 1),
                  child: Column(
                    children: [
                      'Arašidy',
                      'Horčica',
                      'Mlieko',
                      'Morské plody',
                      'Orechy',
                      'Pšenica',
                      'Ryby',
                      'Sezam',
                      'Sója',
                      'Vajcia'
                    ]
                        .map((allergen) => Container(
                              width: double.infinity,
                              height: 60,
                              margin:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: FilterChip(
                                avatar: _allergenIcons[allergen]![
                                    settings.allergens.contains(allergen)
                                        ? 0
                                        : 1],
                                backgroundColor: Colors.white,
                                selectedColor: Colors.white,
                                showCheckmark: false,
                                label: SizedBox(
                                  width: double.infinity,
                                  height: 35,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      allergen,
                                      style: TextStyle(
                                        color: settings.allergens
                                                .contains(allergen)
                                            ? Color.fromRGBO(128, 157, 54, 1)
                                            : Color.fromRGBO(158, 166, 179, 1),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                selected: settings.allergens.contains(allergen),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      settings.allergens.add(allergen);
                                    } else {
                                      settings.allergens.remove(allergen);
                                    }
                                    settings.saveToFirebase();
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildButton(
                    'Performance', performance, const Icon(Icons.trending_up)),
                const SizedBox(height: 20),
                _buildButton(
                    'Security', _panelController.open, const Icon(Icons.lock)),
                const SizedBox(height: 20),
                _buildButton(
                  'Log Out',
                  singOut,
                  const Icon(Icons.logout),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        isDraggable: false,
        panel: _buildSlidingUp(),
        minHeight: 0,
        maxHeight: 290,
        controller: _panelController,
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
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
              color: Colors.white,
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
                      color: Colors.black,
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
                backgroundColor: const Color.fromRGBO(188, 188, 193, 1),
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
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        height: 60,
        child: ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
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
      ),
    );
  }
}
