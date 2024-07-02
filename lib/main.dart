import 'package:flutter/material.dart';

import 'screens/atom_reaction.dart';
import 'screens/clicker_screen.dart';
import 'screens/main_screen.dart';
import 'screens/minesweeper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => const MainScreen(),
        'mine': (BuildContext context) => const Minesweeper(),
        'atom': (BuildContext context) => const AtomReaction(),
        'clicker': (BuildContext context) => const ClickerScreen(),
      },
    );
  }
}
