import 'package:flame/components.dart';
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

  @override
  Future<void> onLoad() async {
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

  void _switchState(PlayerState playerState) => current = playerState;
  void run() => _switchState(PlayerState.run);
  void stop() => _switchState(PlayerState.idle);

  void _switchDirection() {
    flipHorizontally();
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
    super.update(dt);
  }

  void _movePlayer(double dt) {
    switch(current) {
      case PlayerState.run:
        if(_playerDirection.name != gameRef.controllerState.name) _switchDirection();
        switch(_playerDirection) {
          case Direction.right:
            x += gameRef.playerSpeed*dt;
          case Direction.left:
            x -= gameRef.playerSpeed*dt;
        }
        break;
      default:{}
    }
  }
}