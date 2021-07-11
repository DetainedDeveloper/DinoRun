import 'dart:math';
import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/anchor.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/animation.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/components/animation_component.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/spritesheet.dart';
import 'package:flutter_dino/models/enemy_data.dart';

import 'package:flutter_dino/utils/enemy_selector.dart';

class Enemy extends AnimationComponent {
  final String enemyType;

  late EnemyData _enemyData;

  late SpriteSheet _enemyIdleAnimSheet;
  late SpriteSheet _enemyRunAnimSheet;

  late Animation _idleAnim;
  late Animation _runAnim;

  late double speed;

  static Random _random = Random();

  Enemy({required this.enemyType}) : super.empty() {
    
    _enemyData = EnemySelector.enemy(enemyType: enemyType);

    speed = _enemyData.speed;

    _enemyIdleAnimSheet = SpriteSheet(
      imageName: 'characters/enemies/$enemyType/idle.png',
      textureWidth: _enemyData.width,
      textureHeight: _enemyData.height,
      rows: _enemyData.rowsIdle,
      columns: _enemyData.columnsIdle,
    );

    _enemyRunAnimSheet = SpriteSheet(
      imageName: 'characters/enemies/$enemyType/run.png',
      textureWidth: _enemyData.width,
      textureHeight: _enemyData.height,
      rows: _enemyData.rowsRun,
      columns: _enemyData.columnsRun,
    );

    _idleAnim = _enemyIdleAnimSheet.createAnimation(0, from: 0, to: _enemyData.columnsIdle, stepTime: 0.1, loop: true);
    _runAnim = _enemyRunAnimSheet.createAnimation(0, from: 0, to: _enemyData.columnsRun, stepTime: 0.1, loop: true);

    this.anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    super.resize(size);

    this.height = this.width = size.width / 10;
    this.x = size.width + this.width;
    this.y = size.height - this.height * (_enemyData.canFly && _random.nextBool() ? 2 : 1);
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= speed * t;
  }

  @override
  bool destroy() {
    return (this.x < (-this.width));
  }

  Future<void> idle() async => this.animation = _idleAnim;

  Future<void> run() async => this.animation = _runAnim;
}
