// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dino/utils/preferences.dart';

class AudioManager {
  late ValueNotifier<bool> _bg;
  late ValueNotifier<bool> _sfx;

  AudioManager._internal();

  static AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> init(List<String> audioFiles) async {
    Flame.bgm.initialize();
    Flame.audio.loadAll(audioFiles);

    _bg = ValueNotifier(await GamePreferences.getBG());
    _sfx = ValueNotifier(await GamePreferences.getSFX());
  }

  ValueNotifier<bool> get bg => _bg;

  ValueNotifier<bool> get sfx => _sfx;

  Future<void> setBG(bool value) async {
    GamePreferences.setBG(value);
    _bg.value = value;
  }

  Future<void> setSFX(bool value) async {
    GamePreferences.setSFX(value);
    _sfx.value = value;
  }

  Future<void> startBG(String name) async {
    if (_bg.value)
      Flame.bgm.play(name, volume: 0.5);
  }

  Future<void> pauseBG() async {
    if (_bg.value)
      Flame.bgm.pause();
  }

  Future<void> resumeBG() async {
    if (_bg.value)
      Flame.bgm.resume();
  }

  Future<void> stopBG() async {
    if (_bg.value)
      Flame.bgm.stop();
  }

  Future<void> playSFX(String name) async {
    if (_sfx.value)
      Flame.audio.play(name);  }
}
