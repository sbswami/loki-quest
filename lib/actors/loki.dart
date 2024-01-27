import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:lokiquest/actors/enemy.dart';
import 'package:lokiquest/loki_quest.dart';
import 'package:lokiquest/objects/ground_block.dart';
import 'package:lokiquest/objects/platform_block.dart';
import 'package:lokiquest/objects/start.dart';

const double playerSize = 64;

class LokiPlayer extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameRef<LokiQuestGame> {
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 400;
  int horizontalDirection = 0;

  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;

  final double gravity = 15;
  final double jumpSpeed = 600;
  final double terminalVelocity = 400;
  bool hasJumped = false;

  bool hitByEnemy = false;

  LokiPlayer({required super.position}) : super(size: Vector2.all(playerSize), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('loki.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.12,
        textureSize: Vector2.all(16),
      ),
    );

    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA)) ? -1 : 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD)) ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);

    return true;
  }

  @override
  void update(double dt) {
    velocity.y += gravity;
    if (hasJumped) {
      // if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      // }
      hasJumped = false;
    }

    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    velocity.x = horizontalDirection * moveSpeed;

    game.objectSpeed = 0;

    if (position.x - 36 < 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }

    if (position.x + 64 > game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    position.add(velocity * dt);

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (position.y > game.size.y + size.y || position.y < -size.y) {
      game.health = 0;
    }

    if (game.health <= 0) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        position.add(collisionNormal.scaled(separationDistance));
      }
    }

    if (other is Star) {
      other.removeFromParent();
      game.startsCollected++;
    }

    if (other is Enemy) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.1,
          repeatCount: 6,
          alternate: true,
        ),
        onComplete: () {
          hitByEnemy = false;
        },
      ),
    );
  }
}
