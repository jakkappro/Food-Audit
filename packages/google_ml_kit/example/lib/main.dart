import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'helpers/data_helpers.dart';
import 'home.dart';

import 'home_pages/setting_settings_page.dart';
import 'introduction.dart';
import 'login.dart';
import 'models/settings_model.dart';
import 'models/webscraping_model.dart';
import 'register.dart';
import 'settings_pages/performance.dart';
import 'settings_pages/profile.dart';
import 'settings_pages/secuirty.dart';
import 'themes/app_theme.dart';
import 'verify_email.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  cameras = await availableCameras();
  final user = FirebaseAuth.instance.currentUser;
  final userExists = user != null && user.emailVerified;

  //get user settings
  if (userExists) {
    await loadData();
  }

  //get webscraping data
  await WebScrapingModel.receipesInstance.loadFromWeb(true);
  await WebScrapingModel.fitnessInstance.loadFromWeb(false);

  FlutterNativeSplash.remove();
  runApp(
    MaterialApp(
      home: !userExists
          ? LoginPage()
          : SettingsModel.instance.firstTime
              ? IntroPage()
              : HomeScreen(),
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
        '/performance': (context) => PerformancePage(),
        '/introduction': (context) => const IntroPage(),
        '/settings': (context) => const SettingsSettingsPage()
      },
    ),
  );
}
