import 'package:flutter/material.dart';

import 'challenges-card.dart';

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
      child: Column(
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
          Expanded(
            child: ListView(
              children: const [
                ChallengeCard(
                  title: 'Challenge 1',
                  description: 'Description 1',
                  completed: false,
                ),
                ChallengeCard(
                  title: 'Challenge 2',
                  description: 'Description 2',
                  completed: false,
                ),
                ChallengeCard(
                  title: 'Challenge 3',
                  description: 'Description 3',
                  completed: false,
                ),
              ],
            ),
          ),
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
          Expanded(
            child: ListView(
              children: const [
                ChallengeCard(
                  title: 'Challenge 4',
                  description: 'Description 4',
                  completed: false,
                ),
                ChallengeCard(
                  title: 'Challenge 5',
                  description: 'Description 5',
                  completed: false,
                ),
                ChallengeCard(
                  title: 'Challenge 6',
                  description: 'Description 6',
                  completed: false,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Weekly Challenges',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
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
        ],
      ),
    );
  }
}
