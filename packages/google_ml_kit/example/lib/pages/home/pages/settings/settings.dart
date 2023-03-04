import 'package:flutter/material.dart';
import 'package:food_audit/pages/home/pages/settings/pages/profile.dart';

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
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 724,
                child: ProfilePage(),
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
