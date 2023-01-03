import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'register.dart';
import 'settings_pages/food_preferences.dart';
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
      '/profile': (context) => ProfilePage(),
      '/security': (context) => SecurityPage(),
      '/foodPreferences': (context) => FoodPreferencesPage(),
    },
  ));
}
