import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/settings_model.dart';
import '../models/webscraping_model.dart';
import '../testGraph.dart';
import '../widgets/challenges_widgets/challenges_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  List<int> values = [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    _isBlogFinished = false;
    _isLoginFinished = false;
    _isScanFinished = false;
    if (!SettingsModel.isAnonymous) {
      Future.delayed(const Duration(milliseconds: 500), _getChallengesData);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SizedBox(
                      height: 230,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            child: Container(
                              height: 180,
                              width: width * 0.86,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: const Offset(5, 5),
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 22.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Text(
                                              'Denné výzvy',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                              'Plňaj výzvy a získavaj body',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      213, 213, 213, 1),
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        _buildChallengeText(_isLoginFinished,
                                            'Prihlás sa do aplikácie'),
                                        const SizedBox(height: 5),
                                        _buildChallengeText(_isBlogFinished,
                                            'Prečítaj si článok'),
                                        const SizedBox(height: 5),
                                        _buildChallengeText(_isScanFinished,
                                            'Naskenuj produkt'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            height: 50,
                            width: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 0, 0, 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent),
                                onPressed: () {
                                  setState(() {
                                    challengesVisible = true;
                                  });
                                },
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SizedBox(
                      height: 350,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 17,
                            child: Container(
                              height: 280,
                              width: width * 0.82,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(5, 5),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user != null
                                              ? user!.displayName!
                                              : 'Anonym',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 21,
                                              fontWeight: FontWeight.w800),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // graph
                                  const SizedBox(height: 35),
                                  SizedBox(
                                    height: 100,
                                    width: double.infinity,
                                    child: BarChartt(values: values),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Tvoje skóre je ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${values.reduce((a, b) => a + b)} bodov.',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                141, 171, 136, 1),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // here goes friends
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_getImageUrl()),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            height: 50,
                            width: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 0, 0, 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent),
                                onPressed: () {},
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 22),
                        child: Text(
                          'Blog',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 22),
                        child: Text(
                          'Aktuálne trendy v stravovaní',
                          style: TextStyle(
                            color: Color.fromRGBO(218, 218, 218, 1),
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 22.0),
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: 290,
                      child: DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            toolbarHeight: 0,
                            elevation: 0,
                            primary: false,
                            backgroundColor: Colors.transparent,
                            bottom: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: Colors.black,
                              indicatorWeight: 3,
                              isScrollable: false,
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              tabs: [
                                _createTab('Výživa'),
                                _createTab('Cvičenie'),
                                _createTab('Mýtusy'),
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 10),
                                  child: ListView.builder(
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        receipes.image[index]),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    receipes.title[index]
                                                                .length >
                                                            20
                                                        ? '${receipes.title[index].substring(0, 20)}...'
                                                        : receipes.title[index],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      _updateBlogChallenge();
                                                      await launchUrlString(
                                                          receipes.url[index]);
                                                    },
                                                    child: const Text(
                                                      'Čítaj ďalej',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 8,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 10),
                                  child: ListView.builder(
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        fitness.image[index]),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    fitness.title[index]
                                                                .length >
                                                            20
                                                        ? '${fitness.title[index].substring(0, 20)}...'
                                                        : fitness.title[index],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      _updateBlogChallenge();
                                                      await launchUrlString(
                                                          fitness.url[index]);
                                                    },
                                                    child: const Text(
                                                      'Čítaj ďalej',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 8,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 10),
                                  child: ListView.builder(
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        receipes.image[index]),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    receipes.title[index]
                                                                .length >
                                                            30
                                                        ? '${receipes.title[index].substring(0, 20)}...'
                                                        : receipes.title[index],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      _updateBlogChallenge();
                                                      await launchUrlString(
                                                          receipes.url[index]);
                                                    },
                                                    child: const Text(
                                                      'Čítaj ďalej',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 8,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                    width: 300,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ChallengesUI(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeText(bool finished, String text) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1),
            shape: BoxShape.circle,
            border:
                Border.all(color: const Color.fromRGBO(0, 0, 0, 1), width: 1),
          ),
          child: Icon(
            Icons.done,
            color: finished
                ? const Color.fromRGBO(0, 0, 0, 1)
                : Colors.transparent,
            size: 15,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            decoration:
                finished ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Tab _createTab(String name) {
    return Tab(
      child: Container(
        height: 23,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
        ),
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
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

  Future<void> _updateBlogChallenge() async {
    final CollectionReference challengesRef =
        FirebaseFirestore.instance.collection('challenges');
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DateTime now = DateTime.now();
    final String today = '${now.year}-${now.month}-${now.day}';
    final DocumentReference challengeRef = challengesRef.doc(uid);
    final DocumentSnapshot challengeSnapshot = await challengeRef.get();
    final data = challengeSnapshot.data() as Map<String, dynamic>?;
    if (data!['blog'] != today) {
      await challengeRef.set({
        'blog': today,
        now.weekday.toString(): data[now.weekday.toString()] + 15
      }, SetOptions(merge: true));
      setState(() {
        _isBlogFinished = true;
      });
    }
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
