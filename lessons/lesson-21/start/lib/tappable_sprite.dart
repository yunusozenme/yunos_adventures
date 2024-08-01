import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:yunos_adventures/quick_sprite.dart';

typedef OnTapDown = void Function();
class TappableSprite extends PositionComponent with TapCallbacks {
  late final QuickSprite _quickSprite;
  final String _spritePath;
  final double _spriteSize;
  final CoordinatePlane _coordinatePlane;
  final int _alpha;
  final OnTapDown _onTapDown;

  TappableSprite({required String spritePath, required double spriteSize, required CoordinatePlane coordinatePlane,
      int alpha = 240, required OnTapDown onTapDown})
      : _spritePath = spritePath, _spriteSize = spriteSize, _coordinatePlane = coordinatePlane,
      _alpha = alpha, _onTapDown = onTapDown;

  @override
  void onLoad() {
    _quickSprite = QuickSprite(spriteSize: _spriteSize, spritePath: _spritePath, coordinatePlane: _coordinatePlane)
        ..setAlpha(_alpha) ..anchor = Anchor.center ..addToParent(this);
  }

  @override
  void onTapDown(TapDownEvent event) => _onTapDown();

  @override
  bool containsLocalPoint(Vector2 point) {
    final offset = _quickSprite.scaledSize/2;
    return (point.x > -offset.x) && (point.x < offset.x) &&
        (point.y > -offset.y) && (point.y < offset.y);
  }
}