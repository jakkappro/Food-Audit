import 'package:flutter/material.dart';
import 'package:food_audit/pages/home/pages/settings/pages/profile.dart';
import 'dart:math' as math;

import '../../../../models/settings_model.dart';
import '../../../../widgets/settings/borderless_button.dart';

class SettingsPage extends StatelessWidget {
  SettingsModel settings = SettingsModel.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 860,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // rotate the icon to the left
                        Transform.rotate(
                          angle: math.pi / 2, // 90 degrees
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.u_turn_left,
                              size: 25,
                            ),
                          ),
                        ),
                        const Text(
                          'Profil',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 724,
                      child: ProfilePage(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              BorderlessButton(
                label: 'Settings',
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/settings');
                },
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
