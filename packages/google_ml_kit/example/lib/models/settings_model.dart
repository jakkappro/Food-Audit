import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsModel {
  static SettingsModel? _currentInstance;
  Map<String, List<String>> allAlergens = {};
  List<String> allergens = [];
  DateTime birthDate = DateTime.parse('1990-02-27');
  num height = 0;
  num weight = 0;
  num age = 0;
  num imageProcessingFramerate = 0;
  String imageProcessingQuality = '';
  bool _isAnonymous = false;
  bool isMale = true;

  static SettingsModel get instance {
    _currentInstance ??= SettingsModel._internal();
    return _currentInstance!;
  }

  static set isAnonymous(bool value) {
    _currentInstance!._isAnonymous = value;
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
    });
  }

  Future<void> loadFromFirebase() async {
    final doc = await FirebaseFirestore.instance
        .collection('userSettings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.exists) {
      allergens = List<String>.from(doc['Alergens']);
      height = doc['Height'];
      weight = doc['Weight'];
      birthDate = doc['BirthDate'].toDate();
      age = doc['Age'];
      isMale = doc['IsMale'];
      imageProcessingFramerate = doc['ImageProcessingFramerate'];
      imageProcessingQuality = doc['ImageQuality'];
    }

    _getAllAlergensFromFirebase();
  }

  void loadFromFirebaseAnonym() {
    _getAllAlergensFromFirebase();
  }

  void _getAllAlergensFromFirebase() {
    FirebaseFirestore.instance
        .collection('alergens')
        .doc('8gMj50c1wiaDIU0zf1IB')
        .get()
        .then((value) {
      allAlergens = value
          .data()!
          .map((key, value) => MapEntry(key, List<String>.from(value)));
    });
  }
}
