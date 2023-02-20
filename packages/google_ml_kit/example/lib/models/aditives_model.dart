import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

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
    final data = await FirebaseFirestore.instance
        .collection('aditivs')
        .doc('zUmqnGq9nfX5T8M2uupy')
        .get();

    aditivs = data
        .data()!
        .map((key, value) => MapEntry(key, value as Map<String, dynamic>));
  }
}
