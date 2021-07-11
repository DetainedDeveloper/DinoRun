import 'package:flutter/material.dart';
import 'package:flutter_dino/game/dino_game.dart';

class GamePage extends StatefulWidget {
  final String dinoType;

  GamePage({required this.dinoType});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late DinoGame _game;

  @override
  void initState() {
    super.initState();
    _game = DinoGame(dinoType: widget.dinoType, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _game.widget,
    );
  }
}
