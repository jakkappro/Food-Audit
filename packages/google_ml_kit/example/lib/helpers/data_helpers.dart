import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/home/additives/jedalnicek_creation.dart';
import '../models/aditives_model.dart';
import '../models/jedalnicek_model.dart';
import '../models/settings_model.dart';

Future<Map<String, bool>> getChallengesData(User user) async {
  final CollectionReference challengesRef =
      FirebaseFirestore.instance.collection('challenges');
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final DateTime now = DateTime.now();
  final String today = '${now.year}-${now.month}-${now.day}';
  final DocumentReference challengeRef = challengesRef.doc(uid);
  final DocumentSnapshot challengeSnapshot = await challengeRef.get();
  final data = challengeSnapshot.data() as Map<String, dynamic>?;

  if (data != null && data['lastLogin'] != null) {
    final int? lastReset = data['lastReset'];
    if (((lastReset != null && lastReset + 7 < now.day) || now.weekday == 1) &&
        data['2'] != 0) {
      _resetPoints(user);
      await challengeRef.set({
        'lastReset': now.day,
      }, SetOptions(merge: true));
    }
  }

  if (data == null || data['login'] != today) {
    await challengeRef.set({
      'login': today,
      now.weekday.toString(): 10,
      'lastLogin': now.toString()
    }, SetOptions(merge: true));
  }
  if (data == null) {
    return {
      'allergens': false,
      'firstScan': false,
      'shareApp': false,
    };
  }
  return {
    'blog': data['blog'] != null && data['blog'] == today,
    'login': data['login'] != null && data['login'] == today,
    'scan': data['scan'] != null && data['scan'] == today,
  };
}

void _resetPoints(User user) {
  final CollectionReference challengesRef =
      FirebaseFirestore.instance.collection('challenges');
  for (int i = 1; i <= 7; i++) {
    challengesRef.doc(user.uid).update({
      i.toString(): 0,
    });
  }
}

Future<void> loadData() async {
  await SettingsModel.instance.loadFromFirebase();
  SettingsModel.isAnonymous = false;
  await getChallengesData(FirebaseAuth.instance.currentUser!);
  await AditivesModel.instance.loadFromFirebase();
  await JedalnicekModel.instance.loadFromFirebase();
}

Future<void> loadDataAnonymously() async {
  SettingsModel.instance.loadFromFirebaseAnonym();
  await AditivesModel.instance.loadFromFirebase();
  SettingsModel.isAnonymous = true;
}
