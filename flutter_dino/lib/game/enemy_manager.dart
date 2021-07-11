import 'dart:math';
import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/components/component.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/components/mixins/has_game_ref.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/time.dart';
import 'package:flutter_dino/characters/enemy.dart';
import 'package:flutter_dino/game/dino_game.dart';
import 'package:flutter_dino/resources/enemies.dart';

class EnemyManager extends Component with HasGameRef<DinoGame> {
  late int _spawnLevel;
  late Random _random;
  late Timer _timer;

  EnemyManager() {
    _spawnLevel = 0;
    _random = Random();
    _timer = Timer(5, repeat: true, callback: () => spawnRandomEnemy());
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void render(Canvas c) {}

  @override
  void update(double t) {
    _timer.update(t);

    final int _newSpawnLevel = gameRef.dinoScore ~/ 500;

    if (_spawnLevel < _newSpawnLevel) {
      _spawnLevel = _newSpawnLevel;

      final double _newSpawnTime = (5 / (1 + (0.1 * _spawnLevel)));

      _timer.stop();
      _timer = Timer(_newSpawnTime, repeat: true, callback: () => spawnRandomEnemy());
      _timer.start();
    }
  }

  Future<void> spawnRandomEnemy() async {
    final int _randomNumber = _random.nextInt(Enemies.totalEnemies);
    final Enemy _enemy = Enemy(enemyType: Enemies.enemyList[_randomNumber]);
    _enemy.run();
    gameRef.addLater(_enemy);
  }

  Future<void> reset() async {
    _spawnLevel = 0;
    _timer.stop();
    _timer = Timer(5, repeat: true, callback: () => spawnRandomEnemy());
    _timer.start();
  }
}
