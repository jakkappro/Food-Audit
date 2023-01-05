import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsModel {
  static SettingsModel? _currentInstance;
  Map<String, List<String>> allAlergens = {};
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
