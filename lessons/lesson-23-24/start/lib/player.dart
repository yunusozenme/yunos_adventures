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

class Player extends SpriteAnimationGroupComponent<PlayerState> with HasGameReference<YunosAdventures> {
  Direction _playerDirection = Direction.right;
  late double _playerSpeed;
  late double _jumpSpeed;
  late double _gravity;
  late double _initialYPosition;
  double _attackRotation = tau/18; // 20 degrees
  bool _isAttacking = false;
  bool _isJumping = false;

  @override
  Future<void> onLoad() async {
    _playerSpeed = game.playerSpeed;
    _jumpSpeed = game.jumpSpeed;
    _gravity = game.gravity;
    _initialYPosition = game.positionPlayerInitial.y;
    anchor = const Anchor(0.35, 1);
    final spriteSheet = SpriteSheet(image: await game.images.load('sprite_sheet_mascot.png'), srcSize: Vector2(462, 456));

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

  void _switchState(PlayerState playerState) => current = playerState;

  void run() {
    if(!_isAttacking && !_isJumping){
      _switchState(PlayerState.run);
    }
  }

  void jump() {
    _switchState(PlayerState.jump);
    _isJumping = true;
  }

  void stop() => _switchState(PlayerState.idle);

  void attack() {
    _switchState(PlayerState.attack);
    _isAttacking = true;
    final effectController = EffectController(duration: 0.25, reverseDuration: 0.10, atMaxDuration: 0.10, atMinDuration: 0.10);
    final rotationEffect = RotateEffect.by(_attackRotation, effectController, onComplete: _onAttackFinished)
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
    _movePlayer(dt);
    if(_isJumping) _jumpAnimation(dt);
    super.update(dt);
  }

  void _movePlayer(double dt) {
    switch(current) {
      case PlayerState.run:
        _move(dt);
      default:{}
    }
  }
  void _move(double dt) {
    if(_playerDirection.name != game.controllerState.name) _switchDirection();
    x += _playerSpeed*dt;
  }

  void _onAttackFinished() {
    _isAttacking = false;
    _switchState(PlayerState.idle);
  }

  void _jumpAnimation(double dt) {
    if(_initialYPosition >= y) {
      y -= _jumpSpeed * dt - 1/2 * _gravity * dt * dt;
      _jumpSpeed -= _gravity * dt;
      switch(game.controllerState) {
        case ControllerState.right:
        case ControllerState.left:
          _move(dt);
        default:{}
      }
    }
    else {
      y = _initialYPosition;
      _jumpSpeed = game.jumpSpeed;
      _isJumping = false;
      _switchState(PlayerState.idle);
    }
  }
}