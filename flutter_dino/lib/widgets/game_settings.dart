import 'package:flutter/material.dart';
import 'package:flutter_dino/game/audio_manager.dart';

class GameSettings extends StatelessWidget {
  final void Function() onResume;

  GameSettings({required this.onResume});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xE0FFFFFF),
      title: Text('Settings', style: TextStyle(fontSize: 24.0, color: Colors.green)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: AudioManager.instance.bg,
            builder: (context, value, widget) {
              return SwitchListTile(
                value: value,
                title: Text('Background Music'),
                onChanged: (value) => AudioManager.instance.setBG(value),
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: AudioManager.instance.sfx,
            builder: (context, value, widget) {
              return SwitchListTile(
                value: value,
                title: Text('Sound Effects'),
                onChanged: (value) => AudioManager.instance.setSFX(value),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Resume', style: TextStyle(fontSize: 14.0, color: Colors.blue)),
          onPressed: onResume,
        ),
      ],
    );
  }
}
