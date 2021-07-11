// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dino/game/audio_manager.dart';
import 'package:flutter_dino/resources/strings.dart';

import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
  await Flame.util.setLandscape();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await AudioManager.instance.init(['track.wav', 'jump.wav', 'hurt.wav']);
  runApp(DinoRun());
}

class DinoRun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameStrings.appName,
      theme: ThemeData(
        fontFamily: 'GamePlay',
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
