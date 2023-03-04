import 'package:flutter/material.dart';

class DialyChallengesText extends StatelessWidget {
  const DialyChallengesText({
    Key? key,
    this.finished = false,
    required this.text,
  }) : super(key: key);

  final String text;
  final bool finished;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: finished
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.done,
            color: finished
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            size: 15,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            decoration:
                finished ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
