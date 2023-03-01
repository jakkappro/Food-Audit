import 'package:flutter/material.dart';

import '../../../helpers/challenges_helpers.dart';
import 'daily_challenges_text.dart';
import 'package:event/event.dart';

class DailyChallenges extends StatefulWidget {
  DailyChallenges({
    Key? key,
    required this.isLoginFinished,
    required this.isBlogFinished,
    required this.isScanFinished,
  }) : super(key: key);

  bool isLoginFinished;
  bool isBlogFinished;
  bool isScanFinished;

  @override
  State<DailyChallenges> createState() => _DailyChallengesState();
}

class _DailyChallengesState extends State<DailyChallenges> {
  @override
  void initState() {
    super.initState();
    challengeEvent.subscribe((args) {
      setState(() {
        if (args!.value == 'login') {
          widget.isLoginFinished = true;
        } else if (args.value == 'blog') {
          widget.isBlogFinished = true;
        } else if (args.value == 'scan') {
          widget.isScanFinished = true;
        }
      });
    });
  }

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
                finished: widget.isLoginFinished,
                text: 'Prihlás sa do aplikácie',
              ),
              const SizedBox(height: 5),
              DialyChallengesText(
                finished: widget.isBlogFinished,
                text: 'Prečítaj si článok',
              ),
              const SizedBox(height: 5),
              DialyChallengesText(
                finished: widget.isScanFinished,
                text: 'Naskenuj produkt',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
