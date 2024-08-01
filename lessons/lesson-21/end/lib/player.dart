import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:yunos_adventures/direction.dart';
import 'package:yunos_adventures/yunos_adventures.dart';

enum PlayerState {
  idle,
  run,
  jump,
  fall,
  attack,
  dizzy,
  faint,
  slide,
}

class Player extends SpriteAnimationGroupComponent<PlayerState> with HasGameRef<YunosAdventures> {
  Direction _playerDirection = Direction.right;
  late double _playerSpeed;
  double _attackRotation = tau/18; // 20 degrees
  bool _inTransition = false;

  @override
  Future<void> onLoad() async {
    _playerSpeed = gameRef.playerSpeed;
    anchor = const Anchor(0.35, 1);
    final spriteSheet = SpriteSheet(image: await gameRef.images.load('sprite_sheet_mascot.png'), srcSize: Vector2(462, 456));

    final idleAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.4, to: 2);
    final runAnimation = spriteSheet.createAnimation(row: 1, stepTime: 0.2);
    final jumpAnimation = spriteSheet.createAnimation(row: 2, stepTime: 1, to: 1);
    final fallAnimation = spriteSheet.createAnimation(row: 2, stepTime: 1, from: 1, to: 2);
    final attackAnimation = spriteSheet.createAnimation(row: 3, stepTime: 1, to: 1);
    final dizzyAnimation = spriteSheet.createAnimation(row: 4, stepTime: 0.3, to: 2);
    final faintAnimation = spriteSheet.createAnimation(row: 5, stepTime: 1, to: 1);
    final slideAnimation = spriteSheet.createAnimation(row: 6, stepTime: 1, to: 1);

    animations = {
      PlayerState.idle : idleAnimation,
      PlayerState.run : runAnimation,
      PlayerState.jump : jumpAnimation,
      PlayerState.fall : fallAnimation,
      PlayerState.attack : attackAnimation,
      PlayerState.dizzy : dizzyAnimation,
      PlayerState.faint : faintAnimation,
      PlayerState.slide : slideAnimation,
    };

    current = PlayerState.idle;
  }

  void _switchState(PlayerState playerState) {
    if(!_inTransition) current = playerState;
  }
  void run() => _switchState(PlayerState.run);
  void stop() => _switchState(PlayerState.idle);

  void attack() {
    _switchState(PlayerState.attack);
    _inTransition = true;
    final effectController = EffectController(duration: 0.25, reverseDuration: 0.10, atMaxDuration: 0.10, atMinDuration: 0.10);
    final rotationEffect = RotateEffect.by(_attackRotation, effectController, onComplete: _resetState)
      ..addToParent(this);
  }

  void _switchDirection() {
    flipHorizontally();
    _playerSpeed = - _playerSpeed;
    _attackRotation = - _attackRotation;
    switch(_playerDirection) {
      case Direction.left:
        _playerDirection = Direction.right;
      case Direction.right:
        _playerDirection = Direction.left;
    }
  }

  @override
  void update(double dt) {
    if(!_inTransition) _movePlayer(dt);
    super.update(dt);
  }

  void _movePlayer(double dt) {
    switch(current) {
      case PlayerState.run:
        if(_playerDirection.name != gameRef.controllerState.name) _switchDirection();
        x += _playerSpeed*dt;
      default:{}
    }
  }

  void _resetState() {
    _inTransition = false;
    _switchState(PlayerState.idle);
  }
}