import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:yunos_adventures/player.dart';
import 'package:yunos_adventures/quick_sprite.dart';

class YunosAdventures extends FlameGame {
  late final double _tileX;
  late final double _tileY;
  final _player = Player();

  // initial values
  Vector2 get _positionPlayerInitial => Vector2(2*_tileX, 3.25*_tileY);
  Vector2 get _scalingPlayerInitial => Vector2.all(_tileX/_player.width);
  static const _anchorCameraInitial = Anchor(0.25, 0.75);
  static const _zoomCameraInitial = 2.0;

  @override
  Future<void> onLoad() async {
    _tileX = size.x / 10;
    _tileY = size.y / 5;
    final background = QuickSprite(spriteSize: size.y, spritePath: 'world_background.png', coordinatePlane: CoordinatePlane.Y);
    await world.addAll([background, _player]);

    _player.position = _positionPlayerInitial;
    _player.scale = _scalingPlayerInitial;

    camera.viewfinder.anchor = _anchorCameraInitial;
    camera.viewfinder.zoom = _zoomCameraInitial;
    camera.follow(_player);
  }
}
