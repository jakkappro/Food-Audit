
import 'package:flutter/material.dart';

import '../../models/settings_model.dart';
import 'challenges_card.dart';

class ChallengesUI extends StatelessWidget {
  const ChallengesUI(
      {Key? key,
      required this.loginFinished,
      required this.blogFinished,
      required this.scanFinished})
      : super(key: key);
  final bool loginFinished;
  final bool blogFinished;
  final bool scanFinished;
  @override
  Widget build(BuildContext context) {
    // get challenges data from firebase

    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'New User Challenges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ChallengeCard(
                title: 'Nastav si alergeny',
                description: 'Chod do nastavení a nastav si alergeny',
                completed: SettingsModel.instance.challenges['allergens']!,
              ),
              ChallengeCard(
                title: 'Naskenuj prvy produkt',
                description:
                    'Naskenuj první produkt a zjisti, či je bez alergenů',
                completed: SettingsModel.instance.challenges['firstScan']!,
              ),
              ChallengeCard(
                title: 'Zdielaj aplikaciu',
                description: 'Zdielaj aplikaciu s priatelmi',
                completed: SettingsModel.instance.challenges['shareApp']!,
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Daily Challenges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ChallengeCard(
                title: 'Prihlás sa',
                description: 'Prihlás sa do aplikácie',
                completed: loginFinished,
              ),
              ChallengeCard(
                title: 'Naskenuj produkt',
                description: 'Naskenuj produkt a zisti, či je bez alergénov',
                completed: scanFinished,
              ),
              ChallengeCard(
                title: 'Prečítaj si článok',
                description: 'Precitaj si článok o alergeniach',
                completed: blogFinished,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
