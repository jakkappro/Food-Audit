import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer(
      {Key? key,
      required this.body,
      this.leftDecoration,
      required this.width,
      required this.height,
      this.imageUrl,
      this.shouldCenter = true})
      : super(key: key);

  final double width;
  final double height;
  final Widget body;
  final Widget? leftDecoration;
  final String? imageUrl;
  final bool shouldCenter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 10,
              child: SizedBox(
                width: shouldCenter ? width * 0.80 : width * 0.75,
                height: height * 0.9,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 15,
                  child: body,
                ),
              ),
            ),
            if (leftDecoration != null)
              Positioned(
                top: 0,
                right: 0,
                height: 45,
                width: 50,
                child: leftDecoration!,
              ),
            if (imageUrl != null)
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
                      image: NetworkImage(imageUrl!),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
