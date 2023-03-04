import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import '../extensions/firestore_extensions.dart';

class AditivesModel {
  static AditivesModel? _currentInstance;

  Map<String, Map<String, dynamic>> aditivs = {};

  static AditivesModel get instance {
    _currentInstance ??= AditivesModel._internal();
    return _currentInstance!;
  }

  AditivesModel._internal();

  Future<void> loadFromFirebase() async {
    await _getAllAditivesFromFirebase();
  }

  Future<void> _getAllAditivesFromFirebase() async {
    final snap = FirebaseFirestore.instance
        .collection('aditivs')
        .doc('zUmqnGq9nfX5T8M2uupy');

    final data = await snap.getSavy();

    aditivs = data
        .data()!
        .map((key, value) => MapEntry(key, value as Map<String, dynamic>));
  }
}
