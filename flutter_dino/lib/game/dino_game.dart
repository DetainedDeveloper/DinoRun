import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/components/parallax_component.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/components/text_component.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/game.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/gestures.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/position.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/text_config.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dino/characters/dino.dart';
import 'package:flutter_dino/characters/enemy.dart';
import 'package:flutter_dino/game/audio_manager.dart';
import 'package:flutter_dino/game/enemy_manager.dart';
import 'package:flutter_dino/resources/constants.dart';
import 'package:flutter_dino/screens/home_page.dart';
import 'package:flutter_dino/widgets/game_settings.dart';

class DinoGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  final String dinoType;
  final BuildContext context;

  late ParallaxComponent _parallax;
  late Dino _dino;
  late EnemyManager _enemyManager;

  late TextComponent _score;

  double _gameSpeed = GameConstants.gameSpeed;
  int dinoScore = 0;

  bool _paused = false;
  bool _settings = false;
  bool _gameOver = false;

  DinoGame({required this.dinoType, required this.context}) : super() {
    _parallax = ParallaxComponent(
      List.generate(
        11,
        (index) => ParallaxImage('backgrounds/nature/${index + 1}.png'),
      ),
      baseSpeed: Offset(_gameSpeed, 0),
      layerDelta: Offset(GameConstants.parallaxOffset, 0),
    );

    add(_parallax);

    _dino = Dino(dinoType: dinoType);
    _dino.run();
    add(_dino);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    _score = TextComponent(
      dinoScore.toString(),
      config: TextConfig(
        textAlign: TextAlign.center,
        fontFamily: 'GamePlay',
        fontSize: 32.0,
        color: Colors.black54,
      ),
    );

    _score.y = 10;
    add(_score);

    setUpControls();

    AudioManager.instance.startBG('track.wav');
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _score.setByPosition(Position((size.width / 2) - (_score.width / 2), 0));
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    if (!_gameOver && !_paused)
      _dino.jump();
  }

  @override
  void update(double t) {
    super.update(t);
    dinoScore += 1;
    _score.text = dinoScore.toString();
    components.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < enemy.width / 2) _dino.hurt();
    });
    if (_dino.dinoLife.value <= 0) gameOver();
  }

  @override
  void onDetach() {
    AudioManager.instance.stopBG();
    super.onDetach();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        this.pauseGame();
        break;
      case AppLifecycleState.paused:
        this.pauseGame();
        break;
      case AppLifecycleState.detached:
        this.pauseGame();
        break;
    }
  }

  Future<void> setUpControls() async {
    addWidgetOverlay(
      'game_control',
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.pause, size: 32.0, color: Colors.black54),
                iconSize: 32.0,
                onPressed: () => pauseGame(),
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 32.0, color: Colors.black54),
                iconSize: 32.0,
                onPressed: () => restart(),
              ),
              IconButton(
                icon: Icon(Icons.settings, size: 32.0, color: Colors.black54),
                iconSize: 32.0,
                onPressed: () => showSettings(),
              ),
            ],
          ),
          ValueListenableBuilder<int>(
            valueListenable: _dino.dinoLife,
            builder: (context, value, widget) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    6,
                        (index) => Icon(
                      index < value ? Icons.favorite : Icons.favorite_border,
                      size: 32.0,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> pauseGame() async {
    if (!_gameOver && !_paused) {
      pauseEngine();
      _paused = true;
      addWidgetOverlay(
        'pauseMenu',
        AlertDialog(
          backgroundColor: Color(0xE0FFFFFF),
          title: Text('Paused', style: TextStyle(fontSize: 24.0, color: Colors.green)),
          actions: [
            TextButton(
              child: Text('Resume', style: TextStyle(fontSize: 14.0, color: Colors.blue)),
              onPressed: () => resumeGame(),
            ),
            TextButton(
              child: Text('Exit', style: TextStyle(fontSize: 14.0, color: Colors.red)),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
            ),
          ],
        ),
      );
      AudioManager.instance.pauseBG();
    }
  }

  void resumeGame() async {
    resumeEngine();
    _paused = false;
    removeWidgetOverlay('pauseMenu');
    AudioManager.instance.resumeBG();
  }

  Future<void> gameOver() async {
    _gameOver = true;
    pauseEngine();
    _paused = true;
    addWidgetOverlay(
      'gameOverMenu',
      AlertDialog(
        backgroundColor: Color(0xE0FFFFFF),
        title: Text('Game Over', style: TextStyle(fontSize: 24.0, color: Colors.red)),
        content: Text('Your score was $dinoScore', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        actions: [
          TextButton(
            child: Text('Restart', style: TextStyle(fontSize: 14.0, color: Colors.blue)),
            onPressed: () {
              restart();
              resumeEngine();
              _paused = false;
              _gameOver = false;
              removeWidgetOverlay('gameOverMenu');
              AudioManager.instance.resumeBG();
            },
          ),
          TextButton(
            child: Text('Exit', style: TextStyle(fontSize: 14.0, color: Colors.red)),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
          ),
        ],
      ),
    );
    AudioManager.instance.pauseBG();
  }

  Future<void> restart() async {
    this.dinoScore = 0;
    _dino.dinoLife.value = 6;
    _enemyManager.reset();
    components.whereType<Enemy>().forEach(
          (enemy) => this.markToRemove(enemy),
        );
    _dino.run();
  }

  Future<void> showSettings() async {
    if (!_settings) {
      pauseEngine();
      _paused = true;
      _settings = true;
      addWidgetOverlay('settingsMenu', GameSettings(onResume: closeSettings));
      AudioManager.instance.pauseBG();
    }
  }

  Future<void> closeSettings() async {
    resumeEngine();
    _paused = false;
    _settings = false;
    removeWidgetOverlay('settingsMenu');
    AudioManager.instance.resumeBG();
  }
}
