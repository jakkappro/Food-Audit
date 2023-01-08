import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../testGraph.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
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
                        child: Column(children: [
                          const SizedBox(height: 5),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 22.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Denné výzvy',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Plňaj výzvy a získavaj body',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                213, 213, 213, 1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  _buildChallengeText(
                                      false, "Testicko a testovanie"),
                                  const SizedBox(height: 5),
                                  _buildChallengeText(
                                      true, "Testicko a testovanie"),
                                  const SizedBox(height: 5),
                                  _buildChallengeText(
                                      true, "Testicko a testovanie"),
                                ],
                              )),
                        ]),
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20,
                              )),
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  height: 350,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 15,
                        left: 25,
                        child: Container(
                          height: 280,
                          width: width * 0.78,
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
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      user.displayName!,
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
                              SizedBox(height: 35),
                              Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: BarChartt())
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
                                  BorderRadius.all(Radius.circular(20)),
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
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                )),
                          )),
                    ],
                  ),
                )),
          ]),
        ));
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
                  finished ? TextDecoration.lineThrough : TextDecoration.none),
        ),
      ],
    );
  }

  BarChartRodData _buildRodData(bool currentDay, double value) {
    return BarChartRodData(
      color: currentDay
          ? Color.fromRGBO(103, 150, 99, 1)
          : Color.fromRGBO(240, 240, 240, 1),
      width: 25,
      borderRadius: const BorderRadius.all(Radius.zero),
      toY: value,
    );
  }

  String _getImageUrl() {
    return user.photoURL ??
        'https://dummyimage.com/100x100/cf1bcf/ffffff.jpg&text=BRUH+';
  }
}
