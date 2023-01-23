import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'home.dart';

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
      '/performance': (context) => PerformancePage(),
    },
  ));
}

Future<void> _getChallengesData(User user) async {
  final CollectionReference challengesRef =
      FirebaseFirestore.instance.collection('challenges');
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final DateTime now = DateTime.now();
  final String today = '${now.year}-${now.month}-${now.day}';
  final DocumentReference challengeRef = challengesRef.doc(uid);
  final DocumentSnapshot challengeSnapshot = await challengeRef.get();
  final data = challengeSnapshot.data() as Map<String, dynamic>?;

  if (data != null && data['lastLogin'] != null) {
    final int? lastReset = data['lastReset'];
    if ((lastReset != null && lastReset + 7 < now.day) || now.weekday == 1) {
      resetPoints(user);
      await challengeRef.set({
        'lastReset': now.day,
      }, SetOptions(merge: true));
    }
  }

  if (data == null || data['login'] != today) {
    await challengeRef.set({
      'login': today,
      now.weekday.toString(): 10,
      'lastLogin': now.toString()
    }, SetOptions(merge: true));
  }
}

void resetPoints(User user) {
  final CollectionReference challengesRef =
      FirebaseFirestore.instance.collection('challenges');
  for (int i = 1; i <= 7; i++) {
    challengesRef.doc(user.uid).update({
      i.toString(): 0,
    });
  }
}

Future<void> loadData() async {
  await SettingsModel.instance.loadFromFirebase();
  SettingsModel.isAnonymous = false;
  await _getChallengesData(FirebaseAuth.instance.currentUser!);
}

Future<void> loadDataAnonymously() async {
  SettingsModel.instance.loadFromFirebaseAnonym();
  SettingsModel.isAnonymous = true;
}
