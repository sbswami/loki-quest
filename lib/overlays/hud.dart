import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/text.dart';
import 'package:lokiquest/loki_quest.dart';
import 'package:lokiquest/overlays/heart.dart';

class Hud extends PositionComponent with HasGameRef<LokiQuestGame> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;

  @override
  Future<void> onLoad() async {
    _scoreTextComponent = TextComponent(
      text: "${game.startsCollected}",
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
    );

    add(_scoreTextComponent);

    final startSprite = await game.loadSprite('star.png');
    add(SpriteComponent(
      sprite: startSprite,
      position: Vector2(game.size.x - 100, 20),
      size: Vector2.all(32),
      anchor: Anchor.center,
    ));

    for (int i = 1; i <= game.health; i++) {
      final positionX = i * 40.0;
      add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX, 20),
          size: Vector2.all(32),
        ),
      );
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = "${game.startsCollected}";
    super.update(dt);
  }
}
