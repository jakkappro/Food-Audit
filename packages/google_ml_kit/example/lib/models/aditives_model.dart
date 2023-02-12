import 'package:cloud_firestore/cloud_firestore.dart';

class AditivesModel {
  static AditivesModel? _currentInstance;

  Map<String, Map<String, dynamic>> aditivs = {};
  Map<String, String> aditivsDescriptions = {};

  static AditivesModel get instance {
    _currentInstance ??= AditivesModel._internal();
    return _currentInstance!;
  }

  AditivesModel._internal();

  Future<void> loadFromFirebase() async {
    _getAllAditivesFromFirebase();
  }

  void _getAllAditivesFromFirebase() {
    FirebaseFirestore.instance
        .collection('aditivs')
        .doc('zUmqnGq9nfX5T8M2uupy')
        .get()
        .then((value) {
      aditivs = value
          .data()!
          .map((key, value) => MapEntry(key, value as Map<String, dynamic>));
    });
  }
}
