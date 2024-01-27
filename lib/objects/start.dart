import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:lokiquest/loki_quest.dart';

class Star extends SpriteComponent with HasGameRef<LokiQuestGame> {
  final Vector2 gridPosition;
  final double xOffset;
  final Vector2 velocity = Vector2.zero();

  Star({required this.gridPosition, required this.xOffset}) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final starImage = game.images.fromCache('star.png');
    sprite = Sprite(starImage);
    position = Vector2(
      xOffset + gridPosition.x * size.x + size.x / 2,
      game.size.y - (gridPosition.y * size.y + size.y / 2),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(
      SizeEffect.by(
        Vector2(-24, -24),
        EffectController(duration: 0.75, reverseDuration: 0.5, infinite: true, curve: Curves.easeOut),
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
