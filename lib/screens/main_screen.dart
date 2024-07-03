import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Scaffold build(BuildContext context) {
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
                SizedBox(
                  width: 10,
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
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.lightbulb_circle_sharp),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('clicker');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Clicker',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.ads_click_sharp),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('sudoku');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Sudoku',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.crop_free_sharp),
              ],
            ),
          ),
        ],
      );
}
