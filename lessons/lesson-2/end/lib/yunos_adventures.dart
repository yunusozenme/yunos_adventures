import 'package:flame/components.dart';
import 'package:flame/game.dart';

class YunosAdventures extends FlameGame {
  final Vector2 screenSize;
  late final double tileX;
  late final double tileY;
  YunosAdventures(this.screenSize) {
    tileX = screenSize.x/10;
    tileY = screenSize.y/20;
  }

  @override
  Future<void> onLoad() async {
    final worldSprite = await loadSprite('TileSetCombined.png');
    final world = SpriteComponent(sprite: worldSprite);
    final worldScaleRatio = tileY*20/world.height;
    world.scale = Vector2(worldScaleRatio, worldScaleRatio);
    add(world);
  }
}