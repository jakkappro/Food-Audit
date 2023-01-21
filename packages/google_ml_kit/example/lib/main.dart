import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home.dart';

import 'login.dart';
import 'models/settings_model.dart';
import 'register.dart';
import 'settings_pages/food_preferences.dart';
import 'settings_pages/performance.dart';
import 'settings_pages/profile.dart';
import 'settings_pages/secuirty.dart';
import 'themes/app_theme.dart';
import 'verify_email.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  final user = FirebaseAuth.instance.currentUser;
  final userExists = user != null && user.emailVerified;

  if (userExists) {
    await SettingsModel.instance.loadFromFirebase();
    SettingsModel.isAnonymous = false;
  } else {
    SettingsModel.instance.loadFromFirebaseAnonym();
    SettingsModel.isAnonymous = true;
  }

  runApp(MaterialApp(
    home: !userExists ? LoginPage() : HomeScreen(),
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    routes: {
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/verify-email': (context) => VerifyEmailPage(),
      '/home': (context) => HomeScreen(),
      '/profile': (context) => const ProfilePage(),
      '/security': (context) => SecurityPage(),
      '/foodPreferences': (context) => FoodPreferencesPage(),
      '/performance': (context) => PerformancePage(),
    },
  ));
}
