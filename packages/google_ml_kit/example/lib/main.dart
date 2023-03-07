import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';
import 'helpers/data_helpers.dart';
import 'models/allerts_model.dart';
import 'models/connection_model.dart';
import 'models/settings_model.dart';
import 'models/webscraping_model.dart';
import 'pages/authentication/login.dart';
import 'pages/authentication/register.dart';
import 'pages/authentication/verify.dart';
import 'pages/home/home_navigation.dart';
import 'pages/home/pages/settings/pages/performance.dart';
import 'pages/home/pages/settings/pages/profile.dart';
import 'pages/home/pages/settings/pages/security.dart';
import 'pages/home/pages/settings/pages/subsettings.dart';
import 'pages/introduction/introduction.dart';
import 'services/network_connectivity.dart';
import 'themes/app_theme.dart';

List<CameraDescription> cameras = [];

Map _source = {ConnectivityResult.none: false};
final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // check for internet connection
  await _networkConnectivity.initialise();
  _networkConnectivity.myStream.listen((source) {
    _source = source;
    // 1.
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        ConnectionModel.instance.updateConnection(true, false);
        break;
      case ConnectivityResult.wifi:
        ConnectionModel.instance.updateConnection(true, true);
        break;
      case ConnectivityResult.none:
        ConnectionModel.instance.updateConnection(false, false);
        break;
      default:
        break;
    }
  });
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  cameras = await availableCameras();
  final user = FirebaseAuth.instance.currentUser;
  final userExists = user != null && user.emailVerified;

  //get user settings
  if (userExists) {
    await loadData();
  }

  //get webscraping data when internet is available
  if (ConnectionModel.instance.isConnected) {
    await WebScrapingModel.receipesInstance.loadFromWeb(true);
    await WebScrapingModel.fitnessInstance.loadFromWeb(false);
  }

  FlutterNativeSplash.remove();
  runApp(
    MaterialApp(
      home: !userExists
          ? const LoginPage()
          : SettingsModel.instance.firstTime
              ? const IntroPage()
              : const HomeNavigation(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/verify-email': (context) => VerifyEmailPage(),
        '/home': (context) => const HomeNavigation(),
        '/profile': (context) => const ProfilePage(),
        '/security': (context) => const SecurityPage(),
        '/performance': (context) => const PerformancePage(),
        '/introduction': (context) => const IntroPage(),
        '/settings': (context) => const SubSettings()
      },
    ),
  );
}
