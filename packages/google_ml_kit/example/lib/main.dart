import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:food_audit/pages/home/pages/settings/pages/profile.dart';

import 'firebase_options.dart';
import 'helpers/data_helpers.dart';
import 'models/settings_model.dart';
import 'models/webscraping_model.dart';
import 'pages/authentication/login.dart';
import 'pages/authentication/register.dart';
import 'pages/authentication/verify.dart';
import 'pages/home/home_navigation.dart';
import 'pages/home/pages/settings/pages/performance.dart';
import 'pages/home/pages/settings/pages/security.dart';
import 'pages/home/pages/settings/pages/subsettings.dart';
import 'pages/introduction/introduction.dart';
import 'themes/app_theme.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
              ? const IntroPage()
              : HomeNavigation(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/verify-email': (context) => VerifyEmailPage(),
        '/home': (context) => HomeNavigation(),
        '/profile': (context) => const ProfilePage(),
        '/security': (context) => SecurityPage(),
        '/performance': (context) => const PerformancePage(),
        '/introduction': (context) => const IntroPage(),
        '/settings': (context) => const SubSettings()
      },
    ),
  );
}
