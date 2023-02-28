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
}
