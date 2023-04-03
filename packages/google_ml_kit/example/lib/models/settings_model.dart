import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../extensions/firestore_extensions.dart';

class SettingsModel {
  static SettingsModel? _currentInstance;
  Map<String, List<String>> allAlergens = {};
  List<String> allergens = [];
  DateTime birthDate = DateTime.parse('1800-02-27');
  num height = 0;
  num weight = 0;
  num age = 0;
  num imageProcessingFramerate = 0;
  String imageProcessingQuality = '';
  bool _isAnonymous = false;
  bool isMale = true;
  bool firstTime = true;
  List<String>? allergicOn = [];
  String selectedList = 'default';
  Color seedColor = Color.fromRGBO(105, 140, 17, 1);
  String username = '';
  String photoUrl = '';

  Map<String, bool> challenges = {
    'allergens': false,
    'firstScan': false,
    'shareApp': false,
  };
  bool scannedProduct = false;

  static SettingsModel get instance {
    _currentInstance ??= SettingsModel._internal();
    return _currentInstance!;
  }

  static set isAnonymous(bool value) {
    _currentInstance!._isAnonymous = value;
  }

  static bool get isAnonymous {
    return _currentInstance!._isAnonymous;
  }

  SettingsModel._internal();

  Future<void> saveToFirebase() async {
    if (_isAnonymous) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('userSettings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'Alergens': allergens,
      'Height': height,
      'Weight': weight,
      'ImageProcessingFramerate': imageProcessingFramerate,
      'ImageQuality': imageProcessingQuality,
      'BirthDate': birthDate,
      'Age': age,
      'IsMale': isMale,
      'FirstTime': false,
      'Challenges': challenges,
      'SelectedList': selectedList,
      'Color': seedColor.value,
      'Username': username,
      'PhotoUrl': photoUrl,
    });
  }

  Future<void> loadFromFirebase() async {
    await _getAllAlergensFromFirebase();

    final snap = FirebaseFirestore.instance
        .collection('userSettings')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final doc = await snap.getSavy();

    if (doc.exists) {
      allergens = List<String>.from(doc['Alergens']);
      height = doc['Height'];
      weight = doc['Weight'];
      birthDate = doc['BirthDate'].toDate();
      age = doc['Age'];
      isMale = doc['IsMale'];
      imageProcessingFramerate = doc['ImageProcessingFramerate'];
      imageProcessingQuality = doc['ImageQuality'];
      firstTime = doc['FirstTime'];
      challenges = Map<String, bool>.from(doc['Challenges']);
      selectedList = doc['SelectedList'];
      
      if (doc.get('Color') != null) {
        seedColor = Color(doc['Color']);
      }
      
      remapAllergicOn();
    }
  }

  void remapAllergicOn() {
    final filteredMap = {
      for (final key in allAlergens.keys)
        if (allergens.contains(key)) key: allAlergens[key]
    };
    filteredMap.forEach((key, value) {
      allergicOn!.addAll(value!.map(
        (e) => e.toLowerCase(),
      ));
    });
  }

  void loadFromFirebaseAnonym() {
    _getAllAlergensFromFirebase();
  }

  Future<void> _getAllAlergensFromFirebase() async {
    final value = await FirebaseFirestore.instance
        .collection('alergens')
        .doc('8gMj50c1wiaDIU0zf1IB')
        .getSavy();

    allAlergens = value
        .data()!
        .map((key, value) => MapEntry(key, List<String>.from(value)));
  }
}
