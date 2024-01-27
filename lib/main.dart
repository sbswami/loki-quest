import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:lokiquest/loki_quest.dart';
import 'package:lokiquest/overlays/game_over.dart';
import 'package:lokiquest/overlays/main_menu.dart';

void main() {
  runApp(
    GameWidget<LokiQuestGame>.controlled(
      gameFactory: LokiQuestGame.new,
      overlayBuilderMap: {
        'MainMenu': (context, game) => MainMenu(game: game),
        'GameOver': (context, game) => GameOver(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
