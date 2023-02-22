import 'package:cloud_firestore/cloud_firestore.dart';

class JedalnicekModel {
  static JedalnicekModel? _currentInstance;

  List<String> all = [];

  static JedalnicekModel get instance {
    _currentInstance ??= JedalnicekModel._internal();
    return _currentInstance!;
  }

  JedalnicekModel._internal();

  Future<void> loadFromFirebase() async {
    await _getAllAditivesFromFirebase();
  }

  Future<void> _getAllAditivesFromFirebase() async {
    final data = await FirebaseFirestore.instance
        .collection('jedalnicek')
        .get();

    for (final doc in data.docs) {
      all.add(doc.id);
    }
  }
}
