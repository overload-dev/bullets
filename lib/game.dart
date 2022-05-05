import 'package:bullets/knows_game_size.dart';
import 'package:bullets/player.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class SpaceScapeGame extends FlameGame with PanDetector {
  SpaceScapeGame() : super(camera: Camera());

  late Player player;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _joystickRadius = 60;
  final double _deadZoneRadius = 10;

  @override
  Future<void> onLoad() async {
    await images.load('simpleSpace_tilesheet@2.png');

    final spriteSheet = SpriteSheet(
      image: images.fromCache('simpleSpace_tilesheet@2.png'),
      srcSize: Vector2(1024 / 8, 768 / 6),
    );

    player = Player(
      sprite: spriteSheet.getSpriteById(4),
      size: Vector2(64, 64),
      position: size / 2,
    );

    player.anchor = Anchor.center;

    player.canvasSize = canvasSize;

    add(player);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_pointerStartPosition != null) {
      canvas.drawCircle(
        _pointerStartPosition!,
        60,
        Paint()
          ..color = Colors.grey.withAlpha(100),
      );
    }

    if (_pointerCurrentPosition != null) {
      var delta = _pointerCurrentPosition! - _pointerStartPosition!;

      if (delta.distance > 60) {
        delta = _pointerStartPosition! +
            (Vector2(delta.dx, delta.dy).normalized() * _joystickRadius)
                .toOffset();
      } else {
        delta = _pointerCurrentPosition!;
      }

      canvas.drawCircle(
        delta,
        20,
        Paint()
          ..color = Colors.white.withAlpha(100),
      );
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.eventPosition.global.toOffset();
    _pointerCurrentPosition = info.eventPosition.global.toOffset();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _pointerCurrentPosition = Offset(
      info.eventPosition.global.x,
      info.eventPosition.global.y,
    );

    var delta = _pointerCurrentPosition! - _pointerStartPosition!;

    if (delta.distance > _deadZoneRadius) {
      player.setMoveDirection(Vector2(delta.dx, delta.dy));
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }


}
