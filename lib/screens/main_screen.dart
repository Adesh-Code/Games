import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade100,
      body: SafeArea(
        child: _rootWidget(context),
      ),
    );
  }

  Column _rootWidget(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('mine');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Minesweeper',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(Icons.sports_esports_rounded),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('atom');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Atom Reaction',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(Icons.lightbulb_circle_sharp),
              ],
            ),
          ),
        ],
      );
}
