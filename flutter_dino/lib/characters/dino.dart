import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/anchor.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/animation.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/components/animation_component.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/spritesheet.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/time.dart';
import 'package:flutter/widgets.dart' hide Animation;
import 'package:flutter_dino/game/audio_manager.dart';

import 'package:flutter_dino/resources/constants.dart';

class Dino extends AnimationComponent {
  final String dinoType;

  late SpriteSheet _dinoAnimSheet;

  late Animation _idleAnim;
  late Animation _runAnim;
  late Animation _kickAnim;
  late Animation _hurtAnim;
  late Animation _sprintAnim;

  double speedY = 0.0;
  double yMax = 0.0;

  static const double gravity = 900;

  late Timer _timer;
  bool _isHurt = false;

  late ValueNotifier<int> dinoLife;

  Dino({required this.dinoType}) : super.empty() {
    _dinoAnimSheet = SpriteSheet(
      imageName: 'characters/dino/$dinoType.png',
      textureWidth: GameConstants.dinoTextureSize,
      textureHeight: GameConstants.dinoTextureSize,
      rows: GameConstants.rows,
      columns: GameConstants.totalDinos,
    );

    _idleAnim = _dinoAnimSheet.createAnimation(0, from: 0, to: 3, stepTime: 0.1, loop: true);
    _runAnim = _dinoAnimSheet.createAnimation(0, from: 4, to: 10, stepTime: 0.1, loop: true);
    _kickAnim = _dinoAnimSheet.createAnimation(0, from: 11, to: 13, stepTime: 0.1, loop: true);
    _hurtAnim = _dinoAnimSheet.createAnimation(0, from: 14, to: 16, stepTime: 0.1, loop: true);
    _sprintAnim = _dinoAnimSheet.createAnimation(0, from: 17, to: 23, stepTime: 0.1, loop: true);

    _timer = Timer(1, repeat: false, callback: () => run());

    dinoLife = ValueNotifier(6);

    this.anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    super.resize(size);

    this.height = this.width = size.width / 10;
    this.x = this.width;
    this.y = size.height - this.height;

    this.yMax = this.y;
  }

  @override
  void update(double t) {
    super.update(t);

    this.speedY += gravity * t;
    this.y += this.speedY * t;

    if (isOnGround()) {
      this.y = this.yMax;
      this.speedY = 0.0;
    }

    _timer.update(t);
  }

  Future<void> idle() async => this.animation = _idleAnim;

  Future<void> run() async {
    this.animation = _runAnim;
    _isHurt = false;
  }

  Future<void> kick() async => this.animation = _kickAnim;

  Future<void> hurt() async {
    if (!_isHurt) {
      this.animation = _hurtAnim;
      _isHurt = true;
      dinoLife.value -= 1;
      AudioManager.instance.playSFX('hurt.wav');
      _timer.start();
    }
  }

  Future<void> sprint() async => this.animation = _sprintAnim;

  Future<void> jump() async {
    if (isOnGround()) {
      this.speedY = GameConstants.dinoJumpHeight;
      AudioManager.instance.playSFX('jump.wav');
    }
  }

  bool isOnGround() => this.y >= this.yMax;
}
