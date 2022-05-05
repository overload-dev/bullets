import 'package:bullets/knows_game_size.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent with KnowsGameSize {
  Vector2 _moveDirection = Vector2.zero();

  final double _speed = 300;

  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  late Vector2 canvasSize;

  setCanvasSize(Vector2 canvasSize) {
    this.canvasSize = canvasSize;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _moveDirection.normalized() * _speed * dt;
    // 객체가 화면을 벗어나지 않도록
    position.clamp(Vector2.zero() + size / 2, canvasSize - size / 2);
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}
