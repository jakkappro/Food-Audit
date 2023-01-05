import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsModel {
  static SettingsModel? _currentInstance;

  List<String> allergens = [];
  num height = 0;
  num weight = 0;
  num imageProcessingFramerate = 0;
  String imageProcessingQuality = '';

  static SettingsModel get instance {
    _currentInstance ??= SettingsModel._internal();
    return _currentInstance!;
  }

  SettingsModel._internal();

  Future<void> saveToFirebase() async {
    await FirebaseFirestore.instance
        .collection('userSettings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'Alergens': allergens,
      'Height': height,
      'Weight': weight,
      'ImageProcessingFramerate': imageProcessingFramerate,
      'ImageQuality': imageProcessingQuality,
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
      imageProcessingFramerate = doc['ImageProcessingFramerate'];
      imageProcessingQuality = doc['ImageQuality'];
    }
  }
}
