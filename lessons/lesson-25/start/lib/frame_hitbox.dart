import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class FrameHitbox extends RectangleHitbox {
  final _hitboxPaint = Paint()
      ..color = BasicPalette.white.color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

  FrameHitbox({required Vector2 ratio, required Vector2 parentSize}) : super.relative(ratio, parentSize: parentSize);

  @override
  void render(Canvas canvas) {
    if(debugMode) canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _hitboxPaint);
  }
}