import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'coordinates_translator.dart';

class TextRecognizerPainter extends CustomPainter {
  TextRecognizerPainter(this.recognizedText, this.absoluteImageSize,
      this.rotation, this.textToPaint);

  final RecognizedText recognizedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final List<String> textToPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Color.fromRGBO(105, 140, 17, 1);

    final Paint background = Paint()..color = Color(0x99000000);

    for (final textBlock in recognizedText.blocks) {
      for (final textLine in textBlock.lines) {
        for (final textElement in textLine.elements) {
          if (!textToPaint.contains(textElement.text.toLowerCase())) {
            continue;
          }
          final ParagraphBuilder builder = ParagraphBuilder(
            ParagraphStyle(
                textAlign: TextAlign.left,
                fontSize: 16,
                textDirection: TextDirection.ltr),
          );
          builder.pushStyle(ui.TextStyle(
              color: Colors.lightGreenAccent, background: background));
          builder.pop();

          final left = translateX(
              textElement.boundingBox.left, rotation, size, absoluteImageSize);
          final top = translateY(
              textElement.boundingBox.top, rotation, size, absoluteImageSize);
          final right = translateX(
              textElement.boundingBox.right, rotation, size, absoluteImageSize);
          final bottom = translateY(textElement.boundingBox.bottom, rotation,
              size, absoluteImageSize);

          canvas.drawRect(
            Rect.fromLTRB(left, top, right, bottom),
            paint,
          );

          canvas.drawParagraph(
            builder.build()
              ..layout(ParagraphConstraints(
                width: right - left,
              )),
            Offset(left, top),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(TextRecognizerPainter oldDelegate) {
    return oldDelegate.recognizedText != recognizedText;
  }
}
