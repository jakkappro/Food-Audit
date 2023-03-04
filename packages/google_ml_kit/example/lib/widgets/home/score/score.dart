import 'package:flutter/material.dart';
import 'score_graph.dart';

class Score extends StatelessWidget {
  const Score({Key? key, this.username, required this.values})
      : super(key: key);

  final String? username;
  final List<int> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                username ?? 'Anonym',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.secondary,
                ),
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
          child: ScoreGraph(values: values),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Text(
                'Tvoje skóre je ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${values.reduce((a, b) => a + b)} bodov.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // here goes friends
      ],
    );
  }
}
