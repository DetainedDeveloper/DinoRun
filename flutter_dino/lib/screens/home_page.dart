import 'package:flutter/material.dart';
import 'package:flutter_dino/screens/game_page.dart';

class HomePage extends StatelessWidget {
  final List<String> _dinoName = <String>['D', 'I', 'N', 'O', ' ', 'R', 'U', 'N'];

  final List<MaterialColor> _dinoNameColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.lightGreen,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
  ];

  static const List<String> _dinoTypes = <String>[
    'dino_blue',
    'dino_green',
    'dino_light_green',
    'dino_red',
  ];

  static const List<MaterialColor> _dinoBackgrounds = <MaterialColor>[
    Colors.orange,
    Colors.yellow,
    Colors.blue,
    Colors.lightGreen,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/nature.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 128.0, vertical: 64.0),
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Color(0xE0FFFFFF),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  _dinoName.length,
                  (index) => Text(
                    _dinoName[index],
                    style: TextStyle(fontSize: 64.0, color: _dinoNameColors[index]),
                  ),
                ),
              ),
              Text('Select', style: TextStyle(fontSize: 24.0, color: Colors.black54)),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: InkWell(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: _dinoBackgrounds[index],
                        ),
                        child: Image.asset(
                          'assets/images/characters/dino/gifs/${_dinoTypes[index]}.gif',
                          width: 64,
                          height: 64,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(dinoType: _dinoTypes[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
