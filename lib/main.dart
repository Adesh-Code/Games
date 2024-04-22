import 'package:flutter/material.dart';
import 'package:game/screens/minesweeper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.lime.shade50,
        body: const Minesweeper(),
      ),
    );
  }
}
