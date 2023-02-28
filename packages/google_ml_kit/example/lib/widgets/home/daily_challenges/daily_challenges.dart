import 'package:flutter/material.dart';

import 'daily_challenges_text.dart';

class DailyChallenges extends StatelessWidget {
  const DailyChallenges({
    Key? key,
    required this.isLoginFinished,
    required this.isBlogFinished,
    required this.isScanFinished,
  }) : super(key: key);

  final bool isLoginFinished;
  final bool isBlogFinished;
  final bool isScanFinished;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 22.0),
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
                        color: Color.fromRGBO(213, 213, 213, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              DialyChallengesText(
                finished: isLoginFinished,
                text: 'Prihlás sa do aplikácie',
              ),
              const SizedBox(height: 5),
              DialyChallengesText(
                finished: isBlogFinished,
                text: 'Prečítaj si článok',
              ),
              const SizedBox(height: 5),
              DialyChallengesText(
                finished: isScanFinished,
                text: 'Naskenuj produkt',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
