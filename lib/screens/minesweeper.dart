import 'dart:math';

import 'package:flutter/material.dart';

class Minesweeper extends StatefulWidget {
  const Minesweeper({super.key});

  @override
  State<Minesweeper> createState() => _MinesweeperState();
}

class _MinesweeperState extends State<Minesweeper> {
  // width , height
  final (int, int) totalTiles = (10, 10);
  final double _iconSize = 50;
  final int numberOfMines = 10;
  final int distanceForIntialMines = 2;

  bool gameEnd = false;
  bool firstClick = true;

  late List<List<String>> world;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void generateWorld() {
    // init world
    world = [];
    for (int i = 0; i < totalTiles.$1; i++) {
      world.add([]);
      for (var j = 0; j < totalTiles.$2; j++) {
        world[i].add('-');
      }
    }
  }

  void putMines((int, int) tile) {
    for (int i = 0; i < numberOfMines; i++) {
      int randX = Random().nextInt(totalTiles.$1);
      int randY = Random().nextInt(totalTiles.$2);
      while (world[randX][randY] == 'X' || isNearBy((randX, randY), tile)) {
        randX = Random().nextInt(totalTiles.$1);
        randY = Random().nextInt(totalTiles.$2);
      }
      world[randX][randY] = 'X';
    }
  }

  bool isNearBy((int, int) myTile, (int, int) anchorTile) {
    final int x = anchorTile.$1;
    final int y = anchorTile.$2;

    final int x1 = myTile.$1;
    final int y1 = myTile.$2;

    bool isNearBy = false;

    if (x1 > x - distanceForIntialMines &&
        x1 < x + distanceForIntialMines &&
        y1 > y - distanceForIntialMines &&
        y1 < y + distanceForIntialMines) {
      isNearBy = true;
    }

    return isNearBy;
  }

  void assignDangerLevel() {
    for (int i = 0; i < totalTiles.$2; i++) {
      for (int j = 0; j < totalTiles.$1; j++) {
        final val = world[i][j];
        if (val.contains('X')) {
          if (i + 1 < totalTiles.$2) {
            // right
            world[i + 1][j] = appendValue(world[i + 1][j]);
            // top
            if (j - 1 >= 0) {
              world[i + 1][j - 1] = appendValue(world[i + 1][j - 1]);
            }
            // bottom
            if (j + 1 < totalTiles.$1) {
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
            if (j + 1 < totalTiles.$1) {
              world[i - 1][j + 1] = appendValue(world[i - 1][j + 1]);
            }
          }
          if (j + 1 < totalTiles.$1) {
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
    value = value.replaceAll('|', '');
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
      return innerList.map((str) => '${str.replaceAll('|', '')}|').toList();
    }).toList();
    world = newWorld;
  }

  void selectTile((int, int) tile) {
    if (firstClick) {
      putMines(tile);
      assignDangerLevel();
      unSelectAll();
      firstClick = false;
      // for (var ele in world) {
      //   print(ele);
      // }
    }

    final bool isSelected =
        world[tile.$1][tile.$2].contains('|') ? false : true;
    if (!isSelected && !gameEnd) {
      setState(() {
        world[tile.$1][tile.$2] = world[tile.$1][tile.$2].replaceAll('|', '');
      });
    }
    removeNearByWhite(tile);

    if (world[tile.$1][tile.$2] == 'X') {
      gameEnd = true;
      gameOverState();
    }

    bool gameFinished = true;
    for (var row in world) {
      final bool notCompleted = row.any((element) =>
          !(element.contains('-') || element.contains('X')) &&
          element.contains('|'));
      if (notCompleted == true) {
        gameFinished = false;
        break;
      }
    }

    if (gameFinished) {
      gameEnd = true;
      gameWonState();
    }
  }

  // removes white spaces from near 4 directions only
  void removeNearByWhite((int, int) tile) {
    if (world[tile.$1][tile.$2] == '-') {
      if (tile.$1 + 1 < totalTiles.$1 &&
          world[tile.$1 + 1][tile.$2].contains('-')) {
        world[tile.$1 + 1][tile.$2] = '-';
        removeNearByWhite((tile.$1 + 1, tile.$2));
      }
      if (tile.$1 - 1 >= 0 && world[tile.$1 - 1][tile.$2] == '-|') {
        world[tile.$1 - 1][tile.$2] = '-';
        removeNearByWhite((tile.$1 - 1, tile.$2));
      }
      if (tile.$2 + 1 < totalTiles.$2 && world[tile.$1][tile.$2 + 1] == '-|') {
        world[tile.$1][tile.$2 + 1] = '-';
        removeNearByWhite((tile.$1, tile.$2 + 1));
      }
      if (tile.$2 - 1 >= 0 && world[tile.$1][tile.$2 - 1] == '-|') {
        world[tile.$1][tile.$2 - 1] = '-';
        removeNearByWhite((tile.$1, tile.$2 - 1));
      }
    }
  }

  void gameOverState() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('The game has ended.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              restartGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void gameWonState() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Won'),
        content: const Text('The game has ended.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              restartGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void startGame() {
    generateWorld();
    unSelectAll();
  }

  void restartGame() {
    setState(() {
      gameEnd = false;
    });
    startGame();
    setState(() {
      firstClick = true;
    });
  }

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
        return Colors.indigo;
      case '6':
        return Colors.teal;
      case '7':
        return Colors.black;
      case '8':
        return Colors.black;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: (MediaQuery.of(context).size.width / 2) - (_iconSize / 2),
              top: MediaQuery.of(context).size.height / 15,
              child: gameEnd
                  ? SizedBox(
                      child: IconButton(
                        iconSize: _iconSize,
                        icon: const Icon(Icons.replay_rounded),
                        onPressed: restartGame,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Minesweeper',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Arial'),
                ),
              ),
            ),
            Column(
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
            )
          ],
        ),
      ),
    );
  }

  Column _rootWidget() => Column(
        children: List.generate(
          totalTiles.$2,
          (indexCol) => Expanded(
            child: Row(
              children: List.generate(
                totalTiles.$1,
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
          selectTile(position);
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
