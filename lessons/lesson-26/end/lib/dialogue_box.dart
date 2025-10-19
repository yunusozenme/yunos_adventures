import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class DialogueBox extends TextBoxComponent {
  final bgPaint = Paint()
    ..color = BasicPalette.black.color;
  final borderPaint = Paint()
    ..color = BasicPalette.white.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  DialogueBox({required String dialogueText})
    : super(
        text: dialogueText,
        boxConfig: TextBoxConfig(timePerChar: 0.1, dismissDelay: 2),
      );

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect, borderPaint);
    super.render(canvas);
  }
}
