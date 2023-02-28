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
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned(
              top: 15,
              child: SizedBox(
                width: shouldCenter ? width * 0.85 : width * 0.8,
                height: height * 0.8,
                child: Center(
                  child: Container(
                    height: height * 0.8,
                    width: width * 0.8,
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
                    child: body,
                  ),
                ),
              ),
            ),
            if (leftDecoration != null)
              Positioned(
                top: 0,
                right: 0,
                height: 50,
                width: 60,
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
