import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:yunos_adventures/bug_mission_dialogue.dart';
import 'package:yunos_adventures/controller.dart';
import 'package:yunos_adventures/dialogue_box.dart';
import 'package:yunos_adventures/direction.dart';
import 'package:yunos_adventures/frame_hitbox.dart';
import 'package:yunos_adventures/player.dart';
import 'package:yunos_adventures/quick_sprite.dart';
import 'package:yunos_adventures/tappable_sprite.dart';

class YunosAdventures extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final double _tileX;
  late final double _tileY;
  final _player = Player();
  late final QuickSprite _littleBug;
  late final Controller _controller;
  ControllerState _controllerState = ControllerState.middle;
  ControllerState get controllerState => _controllerState;
  late final TappableSprite _attackButton;
  late final BugMissionDialogue _bugMissionDialogue;

  // initial values
  Vector2 get positionPlayerInitial => Vector2(2.5*_tileX, 3.25*_tileY);
  Vector2 get _scalingPlayerInitial => Vector2.all(_tileX/_player.width);
  Vector2 get _positionLittleBug => positionPlayerInitial + Vector2(4*_tileX, 0);
  static const _anchorCameraInitial = Anchor(0.25, 0.75);
  static const _zoomCameraInitial = 2.0;
  double get playerSpeed => _tileX/2;
  double get jumpSpeed => _tileY;
  double get gravity => _tileY*2;
  double get _controllerSize => _tileY;
  double get _attackButtonSize => _tileY*0.80;
  bool get _bugMissionCondition => _player.position.x > 4.5 * _tileX && !_isInTransition && !_isBugMissionCompleted;
  bool _isBugMissionCompleted = false;
  bool _isInTransition = false;
  final isDebugMode = false;

  @override
  Future<void> onLoad() async {
    _tileX = size.x / 10;
    _tileY = size.y / 5;
    final background = QuickSprite(spriteSize: size.y, spritePath: 'world_background.png',
        coordinatePlane: CoordinatePlane.Y);

    _littleBug = QuickSprite(spriteSize: _tileX/2, spritePath: 'little_bug.png',
        coordinatePlane: CoordinatePlane.X)
      ..position = _positionLittleBug
      ..anchor = Anchor(0.5, 1);

    await world.addAll([background, _player, _littleBug]);

    _player.position = positionPlayerInitial;
    _player.scale = _scalingPlayerInitial;

    _controller = Controller(controllerSize: _controllerSize, onTap: _onTapController, onJump: _player.jump)
      ..x = 1.5*_tileX ..y = 4*_tileY;
    _attackButton = TappableSprite(spritePath: 'button_attack.png', spriteSize: _attackButtonSize,
        alpha: 180, coordinatePlane: CoordinatePlane.Y, onTapDown: _player.attack)
      ..x = 9*_tileX ..y = 4*_tileY;
    camera.viewport.addAll([_controller, _attackButton]);

    camera.viewfinder.anchor = _anchorCameraInitial;
    camera.viewfinder.zoom = _zoomCameraInitial;
    camera.follow(_player);

    FrameHitbox(ratio: Vector2(0.8, 0.8), parentSize: background.size)
      ..debugMode = isDebugMode
      ..addToParent(background);
  }


  @override
  void update(double dt) {
    if(_bugMissionCondition) _startBugMission();
    if(_isBugMissionCompleted && _littleBug.x > -_littleBug.size.x) _littleBug.x -= 0.2;
    super.update(dt);
  }

  void _onTapController(ControllerState controllerState) {
    if(!_isInTransition) {
      _controllerState = controllerState;
      switch (controllerState) {
        case ControllerState.middle:
          _player.stop();
        default:
          _player.run();
      }
    }
  }

  void _startBugMission() {
    _player.stop();
    _isInTransition = true;
    _bugMissionDialogue = BugMissionDialogue(dialoguePosition: _player.position + Vector2(_tileX*0.75, -_tileY),
        size : Vector2(_tileX*3, _tileY*1.5), scale : Vector2.all(0.3), onMissionComplete: _onBugMissionComplete)
      ..addToParent(world);
  }

  void _onBugMissionComplete() {
    world.remove(_bugMissionDialogue);
    _isBugMissionCompleted = true;
    _isInTransition = false;
  }
}
