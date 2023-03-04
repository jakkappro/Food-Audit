import 'package:cloud_firestore/cloud_firestore.dart';

import '../extensions/firestore_extensions.dart';

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
    final snap = FirebaseFirestore.instance
        .collection('jedalnicek');
    final data = await snap.getSavy();
    
    for (final doc in data.docs) {
      all.add(doc.id);
    }
  }
}
