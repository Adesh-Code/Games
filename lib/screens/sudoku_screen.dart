import 'dart:math';

import 'package:flutter/material.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  final int worldSize = 9;
  final int emptySpaces = 20;

  List<List<String>> world = [];
  List<(int, int)> _hintLocations = [];
  bool endGame = false;

  bool get allBoxesFilled =>
      !world.any((row) => row.any((cell) => cell.contains('-')));

  @override
  void initState() {
    _startGame();
    super.initState();
  }

  // Generates a world to play in
  void _generateWorld() {
    world = [];
    for (int i = 0; i < worldSize; i++) {
      world.add([]);
      for (var j = 0; j < worldSize; j++) {
        world[i].add('-');
      }
    }
  }

  // Returns integer value of a location; returns -1 if something is wrong
  int _getInteger(String value) {
    value = value.replaceAll('*', '');
    switch (value) {
      case '-':
        return 0;
      case '1':
        return 1;
      case '2':
        return 2;
      case '3':
        return 3;
      case '4':
        return 4;
      case '5':
        return 5;
      case '6':
        return 6;
      case '7':
        return 7;
      case '8':
        return 8;
      case '9':
        return 9;
      default:
        return -1;
    }
  }

  // Generates random Sudoku
  void _startGame() {
    _generateWorld();
    _fillDiagonal();
    _fillRemaining(0, 3);
    _removeDigits();
  }

  // Check if the entire Sudoku mat is solved
  bool _isSolved() {
    for (int i = 0; i < 9; i++) {
      Set<int> rowSet = {};
      Set<int> colSet = {};
      Set<int> boxSet = {};

      for (int j = 0; j < 9; j++) {
        // Parse strings to integers
        int rowNum = _getInteger(world[i][j]);
        int colNum = _getInteger(world[j][i]);

        // Check row
        if (rowNum < 1 || rowNum > 9 || !rowSet.add(rowNum)) {
          return false;
        }
        // Check column
        if (colNum < 1 || colNum > 9 || !colSet.add(colNum)) {
          return false;
        }
        // Check 3x3 subgrid
        int rowIndex = (i ~/ 3) * 3 + j ~/ 3;
        int colIndex = (i % 3) * 3 + j % 3;
        int boxNum = _getInteger(world[rowIndex][colIndex]);
        if (boxNum < 1 || boxNum > 9 || !boxSet.add(boxNum)) {
          return false;
        }
      }
    }
    return true;
  }

  // Fill the diagonal values
  void _fillDiagonal() {
    for (int i = 0; i < 9; i += 3) {
      _fillBox(i, i);
    }
  }

  // Fill a 3 x 3 matrix
  void _fillBox(int row, int col) {
    int num;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        while (true) {
          num = _randomGenerator(9);
          if (_unUsedInBox(row, col, num)) {
            break;
          }
        }
        world[row + i][col + j] = '$num*';
      }
    }
  }

  // Returns false if given 3 x 3 block contains num
  bool _unUsedInBox(int rowStart, int colStart, int num) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (world[rowStart + i][colStart + j].contains('$num')) {
          return false;
        }
      }
    }
    return true;
  }

  // Random generator
  int _randomGenerator(int num) {
    return Random().nextInt(num) + 1;
  }

  // A recursive function to fill remaining matrix
  bool _fillRemaining(int i, int j) {
    if (i == 9 - 1 && j == 9) {
      return true;
    }

    if (j == 9) {
      i += 1;
      j = 0;
    }

    if (!world[i][j].contains('-')) {
      return _fillRemaining(i, j + 1);
    }

    for (int num = 1; num <= 9; num++) {
      if (_checkIfSafe(i, j, num)) {
        world[i][j] = '$num*';
        if (_fillRemaining(i, j + 1)) {
          return true;
        }
        world[i][j] = '-';
      }
    }

    return false;
  }

  // Check if safe to put in cell
  bool _checkIfSafe(int i, int j, int num) {
    return _unUsedInRow(i, num) &&
        _unUsedInCol(j, num) &&
        _unUsedInBox(i - (i % 3), j - (j % 3), num);
  }

  // Check in the row for existence
  bool _unUsedInRow(int i, int num) {
    for (int j = 0; j < 9; j++) {
      if (world[i][j].contains('$num')) {
        return false;
      }
    }
    return true;
  }

  // Check in the row for existence
  bool _unUsedInCol(int j, int num) {
    for (int i = 0; i < 9; i++) {
      if (world[i][j].contains('$num')) {
        return false;
      }
    }
    return true;
  }

  // Remove the some no. of digits to complete game
  void _removeDigits() {
    int count = emptySpaces;

    while (count != 0) {
      int i = Random().nextInt(9);
      int j = Random().nextInt(9);
      if (!world[i][j].contains('-')) {
        count--;
        world[i][j] = '-';
      }
    }
  }

  // append a value
  String _appendValue(String value) {
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
      case '8':
        return '9';
      case '9':
        return '-';
      default:
        return '-';
    }
  }

  void _onClick((int, int) position) {
    if (endGame) {
      return;
    }
    world[position.$1][position.$2] =
        _appendValue(world[position.$1][position.$2]);
    setState(() {});
    if (!allBoxesFilled) {
      return;
    }

    if (_isSolved()) {
      setState(() {
        endGame = true;
      });
    }
  }

  // Get hint
  void _getHint() {
    if (!allBoxesFilled) {
      return;
    }
    for (int i = 0; i < 9; i++) {
      Set<int> rowSet = {};
      Set<int> colSet = {};
      Set<int> boxSet = {};

      for (int j = 0; j < 9; j++) {
        // Parse strings to integers
        int rowNum = _getInteger(world[i][j]);
        int colNum = _getInteger(world[j][i]);

        // Check row
        if (rowNum < 1 || rowNum > 9 || !rowSet.add(rowNum)) {
          _hintLocations.add((rowNum, colNum));
        }
        // Check column
        if (colNum < 1 || colNum > 9 || !colSet.add(colNum)) {
          _hintLocations.add((rowNum, colNum));
        }
        // Check 3x3 subgrid
        int rowIndex = (i ~/ 3) * 3 + j ~/ 3;
        int colIndex = (i % 3) * 3 + j % 3;
        int boxNum = _getInteger(world[rowIndex][colIndex]);
        if (boxNum < 1 || boxNum > 9 || !boxSet.add(boxNum)) {
          _hintLocations.add((rowNum, colNum));
        }
      }
    }
    setState(() {});
    return;
  }

  void _endGame() {
    _startGame();
    endGame = false;
    setState(() {});
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sudoku'),
        leading: const SizedBox.shrink(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SafeArea(
            child: IconButton(
              iconSize: endGame ? 50 : 30,
              onPressed: _endGame,
              icon: const Icon(Icons.restart_alt_sharp),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          endGame
              ? const Text('Sudoku Solved!')
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        _getHint();
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          _hintLocations.clear();
                        });
                      },
                      icon: const Icon(Icons.lightbulb),
                    ),
                    const Text('Know which one are wrong')
                  ],
                ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - 64,
              child: _rootWidget(),
            ),
          ),
        ],
      )),
    );
  }

  Column _rootWidget() => Column(
        children: List.generate(
          worldSize,
          (indexCol) => Expanded(
            child: Row(
              children: List.generate(
                worldSize,
                (indexRow) => _tile(
                  (indexCol, indexRow),
                ),
              ),
            ),
          ),
        ),
      );

  Expanded _tile((int, int) position) {
    // final String raw = world[position.$1][position.$2];
    final String value = world[position.$1][position.$2];
    // final bool isSelected = raw.contains('|') ? false : true;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _onClick(position);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value.contains('*')
                ? Colors.grey
                : _hintLocations.contains(position)
                    ? Colors.red
                    : Colors.transparent,
            border: Border(
              top: BorderSide(
                color: position.$1 != 0
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.5),
              ),
              left: BorderSide(
                color: position.$2 != 0
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.5),
              ),
              right: BorderSide(
                width: position.$2 % 3 != 2 || position.$2 == worldSize - 1
                    ? 1
                    : 2,
                color: position.$2 % 3 != 2 || position.$2 == worldSize - 1
                    ? Colors.black.withOpacity(0.5)
                    : Colors.black,
              ),
              bottom: BorderSide(
                width: position.$1 % 3 != 2 || position.$1 == worldSize - 1
                    ? 1
                    : 2,
                color: position.$1 % 3 != 2 || position.$1 == worldSize - 1
                    ? Colors.black.withOpacity(0.5)
                    : Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              value.toString().replaceAll('*', ''),
              style: TextStyle(
                  color:
                      !value.contains('-') ? Colors.black : Colors.transparent,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
