import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:yunos_adventures/quick_sprite.dart';

class YunosAdventures extends FlameGame {
  final Vector2 screenSize;
  late final double tileX;
  late final double tileY;

  YunosAdventures(this.screenSize) {
    tileX = screenSize.x / 10;
    tileY = screenSize.y / 20;
  }

  @override
  Future<void> onLoad() async {
    final world = QuickSprite(spriteSize: screenSize.y, spritePath: 'TileSetCombined.png', coordinatePlane: CoordinatePlane.Y)
        ..addToParent(this);
  }
}
