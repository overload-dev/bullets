import 'package:flame/components.dart';

mixin KnowsGameSize on Component {
  Vector2? gameSize;

  void onResize(Vector2 newGameSize) {
    gameSize = newGameSize;
  }
}
