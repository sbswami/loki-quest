import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:lokiquest/actors/loki.dart';
import 'package:lokiquest/managers/segment_manager.dart';
import 'package:lokiquest/overlays/hud.dart';

import 'actors/enemy.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';
import 'objects/start.dart';

class LokiQuestGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late LokiPlayer _loki;
  double objectSpeed = 0.0;

  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  int startsCollected = 0;
  int health = 5;

  LokiQuestGame();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 173, 223, 247);

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'enemy.png',
      'ground.png',
      'heart.png',
      'heart_half.png',
      'loki.png',
      'star.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;

    initializeGame(true);

    return super.onLoad();
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          add(GroundBlock(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case PlatformBlock:
          add(PlatformBlock(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case Enemy:
          add(Enemy(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case Star:
          add(Star(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
      }
    }
  }

  void initializeGame(bool loadHud) {
    // 640px is size of 10 segments, each segment is 64px wide
    final segmentToLoad = (size.x / 640).ceil();
    segmentToLoad.clamp(0, segments.length);

    for (int i = 0; i < segmentToLoad; i++) {
      loadGameSegments(i, (i * 640).toDouble());
    }

    _loki = LokiPlayer(position: Vector2(128, canvasSize.y - 128));

    world.add(_loki);
    if (loadHud) {
      world.add(Hud());
    }
  }

  void reset() {
    startsCollected = 0;
    health = 5;
    initializeGame(false);
  }

  @override
  void update(double dt) {
    if(health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }
}
