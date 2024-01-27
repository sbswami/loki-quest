import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:lokiquest/loki_quest.dart';

class PlatformBlock extends SpriteComponent with HasGameRef<LokiQuestGame> {
  final Vector2 gridPosition;
  final double xOffset;

  final Vector2 velocity = Vector2.zero();

  PlatformBlock({required this.gridPosition, required this.xOffset})
      : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    final platformImage = game.images.fromCache('block.png');
    sprite = Sprite(platformImage);
    position = Vector2(xOffset + (gridPosition.x * size.x), game.size.y - (gridPosition.y * size.y));
    add(RectangleHitbox(collisionType: CollisionType.passive));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position.add(velocity * dt);
    if (position.x < -size.x || game.health <= 0) removeFromParent();
    super.update(dt);
  }
}
