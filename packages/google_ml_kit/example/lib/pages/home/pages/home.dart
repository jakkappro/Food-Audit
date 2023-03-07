import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/allerts_model.dart';
import '../../../models/jedalnicek_model.dart';
import '../../../models/settings_model.dart';
import '../../../models/webscraping_model.dart';
import '../../../widgets/challenges_widgets/challenges_widget.dart';
import '../../../widgets/home/additives/additives.dart';
import '../../../widgets/home/additives/jedalnicek_creation.dart';
import '../../../widgets/home/allerts/allerts.dart';
import '../../../widgets/home/blog/blogs.dart';
import '../../../widgets/home/daily_challenges/daily_challenges.dart';
import '../../../widgets/home/decorated_container.dart';
import '../../../widgets/home/score/score.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = FirebaseAuth.instance.currentUser;
  final contorller = ScrollController();
  final scrollController = ScrollController();
  final receipes = WebScrapingModel.receipesInstance;
  final fitness = WebScrapingModel.fitnessInstance;
  final settings = SettingsModel.instance;
  late bool _isLoginFinished;
  late bool _isBlogFinished;
  late bool _isScanFinished;
  bool challengesVisible = false;
  bool challengesVisibleJedlo = false;
  List<int> values = [0, 0, 0, 0, 0, 0, 0];
  List<String> filteredJedalnicky = [];
  bool loadedAllerts = false;

  @override
  void initState() {
    _isBlogFinished = false;
    _isLoginFinished = false;
    _isScanFinished = false;
    filteredJedalnicky.addAll(JedalnicekModel.instance.all);
    if (!SettingsModel.isAnonymous) {
      Future.delayed(const Duration(milliseconds: 500), _getChallengesData);
    }
    AllertsModel.allertsInstance.loadFromWeb().then((value) => {
          setState(() {
            loadedAllerts = true;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    DecoratedContainer(
                      body: Allerts(
                        allerts: loadedAllerts
                            ? AllertsModel.allertsInstance.title
                            : null,
                      ),
                      width: width,
                      height: 430,
                    ),
                    DecoratedContainer(
                      body: DailyChallenges(
                        isLoginFinished: _isLoginFinished,
                        isBlogFinished: _isBlogFinished,
                        isScanFinished: _isScanFinished,
                      ),
                      width: width,
                      height: 220,
                      leftDecoration: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            challengesVisible = true;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DecoratedContainer(
                      body: Score(
                        values: values,
                        username: user != null ? user!.displayName : '',
                      ),
                      width: width,
                      height: 300,
                      leftDecoration: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            challengesVisible = true;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                      imageUrl: _getImageUrl(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Blogs(),
                    const SizedBox(
                      height: 20,
                    ),
                    Additives(
                        width: width,
                        onTap: () => setState(() {
                              challengesVisibleJedlo = true;
                            })),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: challengesVisible,
                child: GestureDetector(
                  onTap: () => setState(() => challengesVisible = false),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                  ),
                ),
              ),
              Visibility(
                visible: challengesVisible,
                child: Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: width * 0.85,
                      height: height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ChallengesUI(
                        loginFinished: true,
                        blogFinished: _isBlogFinished,
                        scanFinished: _isScanFinished,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: challengesVisibleJedlo,
                child: GestureDetector(
                  onTap: () => setState(() => challengesVisibleJedlo = false),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                  ),
                ),
              ),
              Visibility(
                visible: challengesVisibleJedlo,
                child: Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: 300,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: JedalnicekCreation()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImageUrl() {
    return user != null
        ? user!.photoURL ??
            'https://dummyimage.com/100x100/cf1bcf/ffffff.jpg&text=BRUH+'
        : 'https://dummyimage.com/100x100/cf1bcf/ffffff.jpg&text=BRUH+';
  }

  Future<void> _getChallengesData() async {
    final CollectionReference challengesRef =
        FirebaseFirestore.instance.collection('challenges');
    bool isBlogFinished = false;
    bool isScanFinished = false;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DateTime now = DateTime.now();
    final String today = '${now.year}-${now.month}-${now.day}';
    final DocumentReference challengeRef = challengesRef.doc(uid);
    final DocumentSnapshot challengeSnapshot = await challengeRef.get();
    final data = challengeSnapshot.data() as Map<String, dynamic>?;

    if (data != null && data['blog'] == today) {
      isBlogFinished = true;
    }
    if (data != null && data['scan'] == today) {
      isScanFinished = true;
    }

    for (int i = 1; i < 8; i++) {
      if (data != null && data[i.toString()] != null) {
        values[i - 1] = data[i.toString()];
      }
    }

    setState(() {
      _isBlogFinished = isBlogFinished;
      _isScanFinished = isScanFinished;
      _isLoginFinished = true;
    });
  }
}
