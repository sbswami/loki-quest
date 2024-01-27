import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:lokiquest/loki_quest.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef<LokiQuestGame> {
  final Vector2 gridPosition;
  final double xOffset;
  final Vector2 velocity = Vector2.zero();

  Enemy({required this.gridPosition, required this.xOffset}) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.7,
        textureSize: Vector2.all(16),
      ),
    );

    position = Vector2(xOffset + (gridPosition.x * size.x), game.size.y - (gridPosition.y * size.y));
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(
      MoveEffect.by(
        Vector2(-2 * size.x, 0),
        EffectController(duration: 3, infinite: true, alternate: true),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position.add(velocity * dt);
    if(position.x < -size.x || game.health <= 0) removeFromParent();
    super.update(dt);
  }
}
