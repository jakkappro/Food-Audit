import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/event.dart';
import 'package:firebase_auth/firebase_auth.dart';

Event<Value<String>> challengeEvent = Event<Value<String>>();

Future<void> updateBlogChallenge() async {
  await _updateChallenge('blog');
  challengeEvent.broadcast(Value('blog'));
}

Future<void> updateFitnessChallenge() async {
  await _updateChallenge('login');
  challengeEvent.broadcast(Value('login'));
}

Future<void> updateScanChallenge() async {
  await _updateChallenge('scan');
  challengeEvent.broadcast(Value('scan'));
}

Future<void> _updateChallenge(String toUpdate) async {
  final CollectionReference challengesRef =
      FirebaseFirestore.instance.collection('challenges');
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final DateTime now = DateTime.now();
  final String today = '${now.year}-${now.month}-${now.day}';
  final DocumentReference challengeRef = challengesRef.doc(uid);
  final DocumentSnapshot challengeSnapshot = await challengeRef.get();
  final data = challengeSnapshot.data() as Map<String, dynamic>?;
  if (data![toUpdate] != today) {
    await challengeRef.set({
      toUpdate: today,
      now.weekday.toString(): data[now.weekday.toString()] + 15
    }, SetOptions(merge: true));
  }
}
