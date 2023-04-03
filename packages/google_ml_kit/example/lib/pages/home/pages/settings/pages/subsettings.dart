import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_audit/pages/home/pages/settings/pages/accesibility.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../models/settings_model.dart';
import '../../../../../widgets/settings/borderless_button.dart';
import '../../../../../widgets/settings/confirm_password_slidingup.dart';
import '../../../../authentication/login.dart';
import 'appearence.dart';
import 'performance.dart';
import 'security.dart';

class SubSettings extends StatefulWidget {
  const SubSettings({Key? key}) : super(key: key);

  @override
  State<SubSettings> createState() => _SubSettingsState();
}

class _SubSettingsState extends State<SubSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final PanelController _panelController = PanelController();

  SettingsModel settings = SettingsModel.instance;

  final _passwordController = TextEditingController();

  Future<bool> checkPassword() async {
    final credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: _passwordController.text.trim());

    try {
      final result =
          await _auth.currentUser!.reauthenticateWithCredential(credential);
      if (result.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: SlidingUpPanel(
          isDraggable: false,
          panel: ConfirmPasswordSlidingUp(
            onConfirm: () async {
              if (await checkPassword()) {
                _panelController.close();
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SecurityPage()));
              }
            },
            panelController: _panelController,
            passwordController: _passwordController,
          ),
          minHeight: 0,
          maxHeight: 300,
          color: Theme.of(context).colorScheme.surfaceVariant,
          controller: _panelController,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1000,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  BorderlessButton(
                    label: 'Performance',
                    onPressed: () async => await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PerformancePage()),
                    ),
                    icon: const Icon(Icons.trending_up),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 20),
                  BorderlessButton(
                    label: 'Security',
                    onPressed: _panelController.open,
                    icon: const Icon(Icons.lock),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 20),
                  BorderlessButton(
                    label: 'Language',
                    onPressed: () async => await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PerformancePage()),
                    ),
                    icon: const Icon(Icons.language),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 20),
                  BorderlessButton(
                    label: 'Appearence',
                    onPressed: () async => await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AppearancePage(),
                      ),
                    ),
                    icon: const Icon(Icons.color_lens),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(height: 20),
                  BorderlessButton(
                    onPressed: () async => await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AccesibilityPage())),
                    icon: Icon(Icons.accessibility),
                    color: Theme.of(context).colorScheme.secondary,
                    label: 'Accesibility',
                  ),
                  const SizedBox(height: 20),
                  BorderlessButton(
                    label: 'Log Out',
                    onPressed: () async {
                      await _auth.signOut();
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
