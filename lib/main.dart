import 'package:flutter/material.dart';
import 'package:minesweeper/screens/minesweeper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lime.shade50,
        body: Minesweeper(),
      ),
    );
  }
}
