import 'dart:math';

import 'package:flutter/material.dart';

class Minesweeper extends StatefulWidget {
  const Minesweeper({super.key});

  @override
  State<Minesweeper> createState() => _MinesweeperState();
}

class _MinesweeperState extends State<Minesweeper> {
  // width , height
  final (int, int) tiles = (10, 10);

  late List<List<String>> world;
  bool gameEnd = false;
  final int numberOfMines = 20;
  bool firstClick = true;

  @override
  void initState() {
    super.initState();
    generateWorld();
    unSelectAll();
  }

  void generateWorld() {
    // init world
    world = [];
    for (int i = 0; i < tiles.$1; i++) {
      world.add([]);
      for (var j = 0; j < tiles.$2; j++) {
        world[i].add('-');
      }
    }
  }

  void putMines({required (int, int) tile}) {
    for (int i = 0; i < numberOfMines; i++) {
      int randX = Random().nextInt(tiles.$1);
      int randY = Random().nextInt(tiles.$2);
      while (world[randX][randY] == 'X' || tile == (randX, randY)) {
        randX = Random().nextInt(tiles.$1);
        randY = Random().nextInt(tiles.$2);
      }
      world[randX][randY] = 'X';
    }
  }

  void assignDangerLevel() {
    for (int i = 0; i < tiles.$2; i++) {
      for (int j = 0; j < tiles.$1; j++) {
        final val = world[i][j];
        if (val == 'X') {
          if (i + 1 < tiles.$2) {
            // right
            world[i + 1][j] = appendValue(world[i + 1][j]);
            // top
            if (j - 1 >= 0) {
              world[i + 1][j - 1] = appendValue(world[i + 1][j - 1]);
            }
            // bottom
            if (j + 1 < tiles.$1) {
              world[i + 1][j + 1] = appendValue(world[i + 1][j + 1]);
            }
          }
          if (i - 1 >= 0) {
            // left
            world[i - 1][j] = appendValue(world[i - 1][j]);
            // top
            if (j - 1 >= 0) {
              world[i - 1][j - 1] = appendValue(world[i - 1][j - 1]);
            }
            // bottom
            if (j + 1 < tiles.$1) {
              world[i - 1][j + 1] = appendValue(world[i - 1][j + 1]);
            }
          }
          if (j + 1 < tiles.$1) {
            world[i][j + 1] = appendValue(world[i][j + 1]);
          }
          if (j - 1 >= 0) {
            world[i][j - 1] = appendValue(world[i][j - 1]);
          }
        }
      }
    }
  }

  String appendValue(String value) {
    switch (value) {
      case '-':
        return '1';
      case '1':
        return '2';
      case '2':
        return '3';
      case '3':
        return '4';
      case '4':
        return '5';
      case '5':
        return '6';
      case '6':
        return '7';
      case '7':
        return '8';
      case 'X':
        return 'X';
      default:
        return '-';
    }
  }

  void unSelectAll() {
    List<List<String>> newWorld = world.map((innerList) {
      return innerList.map((str) => '$str|').toList();
    }).toList();
    world = newWorld;
  }

  void selectTile({required (int, int) tile}) {
    if (firstClick) {
      putMines(tile: tile);
      assignDangerLevel();
      unSelectAll();
      firstClick = false;
    }

    final bool isSelected =
        world[tile.$1][tile.$2].contains('|') ? false : true;
    if (!isSelected && !gameEnd) {
      setState(() {
        world[tile.$1][tile.$2] = world[tile.$1][tile.$2].replaceAll('|', '');
      });
    }
    if (world[tile.$1][tile.$2] == 'X') {
      gameEnd = true;
      gameOverState();
    }
  }

  void gameOverState() {}

  Color _getColor(String value) {
    switch (value) {
      case '-':
        return Colors.transparent;
      case '1':
        return Colors.blue;
      case '2':
        return Colors.green;
      case '3':
        return Colors.orange;
      case '4':
        return Colors.red;
      case '5':
        return Colors.deepPurple;
      default:
        return Colors.red;
    }
  }

  @override
  SafeArea build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - 64,
              child: _rootWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Column _rootWidget() => Column(
        children: List.generate(
          tiles.$2,
          (indexCol) => Expanded(
            child: Row(
              children: List.generate(
                tiles.$1,
                (indexRow) => _tile(
                  (indexCol, indexRow),
                ),
              ),
            ),
          ),
        ),
      );

  Expanded _tile((int, int) position) {
    final String raw = world[position.$1][position.$2];
    final String value = world[position.$1][position.$2].replaceAll('|', '');
    final bool isSelected = raw.contains('|') ? false : true;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectTile(tile: position);
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: isSelected ? null : _boxShadow,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                  color: isSelected ? _getColor(value) : Colors.transparent,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  static List<BoxShadow> get _boxShadow => [
        BoxShadow(
          offset: const Offset(1, 1),
          color: Colors.black.withOpacity(0.5),
        )
      ];
}
