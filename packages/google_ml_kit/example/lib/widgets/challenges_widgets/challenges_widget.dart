import 'package:flutter/material.dart';

import 'challenges_card.dart';

class ChallengesUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            Padding(
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
              completed: false,
            ),
            ChallengeCard(
              title: 'Naskenuj prvy produkt',
              description:
                  'Naskenuj první produkt a zjisti, jestli je bez alergenů',
              completed: false,
            ),
            ChallengeCard(
              title: 'Zdielaj aplikaciu',
              description: 'Zdielaj aplikaciu s priatelmi',
              completed: false,
            ),
            Padding(
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
              title: 'Prihlas sa',
              description: 'Prihlas sa do aplikacie',
              completed: false,
            ),
            ChallengeCard(
              title: 'Naskenuj produkt',
              description: 'Naskenuj produkt a zisti, jestli je bez alergenů',
              completed: false,
            ),
            ChallengeCard(
              title: 'Precitaj si blog',
              description: 'Precitaj si blog o alergeniach',
              completed: false,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Weekly Challenges, TODO: add more challenges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ChallengeCard(
              title: 'Challenge 7',
              description: 'Description 7',
              completed: false,
            ),
            ChallengeCard(
              title: 'Challenge 8',
              description: 'Description 8',
              completed: true,
            ),
            ChallengeCard(
              title: 'Challenge 9',
              description: 'Description 9',
              completed: true,
            ),
          ],
        ),
      ),
    );
  }
}
