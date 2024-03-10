import 'package:flame/components.dart';
enum CoordinatePlane {
  X, Y
}

class QuickSprite extends SpriteComponent with HasGameRef {
  final double spriteSize;
  final String spritePath;
  final CoordinatePlane coordinatePlane;

  QuickSprite({required this.spriteSize, required this.spritePath, required this.coordinatePlane});

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(spritePath);
    size = sprite!.originalSize;

    switch(coordinatePlane) {
      case CoordinatePlane.X:
        scale = Vector2.all(spriteSize/width);
        break;
      case CoordinatePlane.Y:
        scale = Vector2.all(spriteSize/height);
        break;
    }
  }
}