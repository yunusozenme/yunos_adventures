import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:yunos_adventures/direction.dart';
import 'package:yunos_adventures/quick_sprite.dart';
import 'package:yunos_adventures/yunos_adventures.dart';

typedef OnTapCallBack = void Function(ControllerState);
class Controller extends PositionComponent with HasGameRef<YunosAdventures>, TapCallbacks, KeyboardHandler {
  late final QuickSprite _background;
  late final QuickSprite _stick;
  late final double _stickOffset;
  final double controllerSize;
  final OnTapCallBack onTap;

  Controller({required this.controllerSize, required this.onTap});

  @override
  Future<void> onLoad() async {
    _background = QuickSprite(spriteSize: controllerSize, spritePath: 'controller_background.png', coordinatePlane: CoordinatePlane.Y)
      ..anchor = Anchor.center ..setAlpha(120);
    _stick = QuickSprite(spriteSize: controllerSize*0.80, spritePath: 'controller_stick.png', coordinatePlane: CoordinatePlane.Y)
      ..anchor = Anchor.center ..setAlpha(180);

    await addAll([_background, _stick]);
    _stickOffset = _background.scaledSize.x/4;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if(event.localPosition.x > 0) onTap(ControllerState.right);
    else onTap(ControllerState.left);
  }

  @override
  void onTapUp(TapUpEvent event) => onTap(ControllerState.middle);

  @override
  void onTapCancel(TapCancelEvent event) => onTap(ControllerState.middle);

  @override
  bool containsLocalPoint(Vector2 point) {
    final offset = _background.scaledSize/2;
    return (point.x > -offset.x) && (point.x < offset.x) &&
      (point.y > -offset.y) && (point.y < offset.y);
  }

  @override
  void update(double dt) {
    _moveStick(dt);
    super.update(dt);
  }

  void _moveStick(double dt) {
    if(gameRef.controllerState == ControllerState.right && _stick.x < _stickOffset) _stick.x += controllerSize*dt;
    if(gameRef.controllerState == ControllerState.left && _stick.x > -_stickOffset) _stick.x -= controllerSize*dt;
    if(gameRef.controllerState == ControllerState.middle) _stick.x = 0;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if(event.physicalKey == PhysicalKeyboardKey.keyA) onTap(ControllerState.left);
    else if(event.physicalKey == PhysicalKeyboardKey.keyD) onTap(ControllerState.right);
    else if(event.physicalKey == PhysicalKeyboardKey.keyS) onTap(ControllerState.middle);
    return false;
  }
}