import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:yunos_adventures/controller.dart';
import 'package:yunos_adventures/direction.dart';
import 'package:yunos_adventures/player.dart';
import 'package:yunos_adventures/quick_sprite.dart';

class YunosAdventures extends FlameGame with HasKeyboardHandlerComponents {
  late final double _tileX;
  late final double _tileY;
  final _player = Player();
  late final Controller _controller;
  ControllerState _controllerState = ControllerState.middle;
  ControllerState get controllerState => _controllerState;


  // initial values
  Vector2 get _positionPlayerInitial => Vector2(2*_tileX, 3.25*_tileY);
  Vector2 get _scalingPlayerInitial => Vector2.all(_tileX/_player.width);
  static const _anchorCameraInitial = Anchor(0.25, 0.75);
  static const _zoomCameraInitial = 2.0;
  double get playerSpeed => _tileX/2;
  double get _controllerSize => _tileY;

  @override
  Future<void> onLoad() async {
    _tileX = size.x / 10;
    _tileY = size.y / 5;
    final background = QuickSprite(spriteSize: size.y, spritePath: 'world_background.png', coordinatePlane: CoordinatePlane.Y);
    await world.addAll([background, _player]);

    _player.position = _positionPlayerInitial;
    _player.scale = _scalingPlayerInitial;

    _controller = Controller(controllerSize: _controllerSize, onTap: onTapController)
      ..x = 1.5*_tileX ..y = 4*_tileY;
    camera.viewport.add(_controller);

    camera.viewfinder.anchor = _anchorCameraInitial;
    camera.viewfinder.zoom = _zoomCameraInitial;
    camera.follow(_player);
  }

  void onTapController(ControllerState controllerState) {
    _controllerState = controllerState;
    switch(controllerState) {
      case ControllerState.middle:
        _player.stop();
      default:
        _player.run();
    }
  }
}
