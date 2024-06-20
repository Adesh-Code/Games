import 'package:flutter/material.dart';

enum TilePos { center, side, corner }

class AtomReaction extends StatefulWidget {
  const AtomReaction({super.key});

  @override
  State<AtomReaction> createState() => _AtomReactionState();
}

class _AtomReactionState extends State<AtomReaction> {
  final double _iconSize = 50;
  final (int, int) totalTiles = (8, 8);
  bool? _winner;
  List<List<String>> world = [];
  bool loading = false;
  bool _playerOne = true;

  @override
  void initState() {
    super.initState();
    generateWorld();
  }

  void generateWorld() {
    for (int i = 0; i < totalTiles.$1; i++) {
      world.add([]);
      for (int j = 0; j < totalTiles.$2; j++) {
        world[i].add('0');
      }
    }
  }

  void _selectTile((int, int) position, bool recursive, bool playerOne) {
    final prefix = playerOne == false ? '-' : '';

    // Should not be able to place atom on wrong player side
    if (recursive == false && !(world[position.$1][position.$2] == '0')) {
      if (!(world[position.$1][position.$2].contains('-')) && prefix == '-') {
        return;
      }
      if (world[position.$1][position.$2].contains('-') && prefix == '') {
        return;
      }
    }

    switch (world[position.$1][position.$2]) {
      case '0':
        world[position.$1][position.$2] = "${prefix}1";
      case '-1':
      case '1':
        switch (_getTilePos(position)) {
          case TilePos.center:
          case TilePos.side:
            world[position.$1][position.$2] = '${prefix}2';
            break;
          case TilePos.corner:
            _blastAtom(position, playerOne);
            break;
        }
        break;
      case '2':
      case '-2':
        switch (_getTilePos(position)) {
          case TilePos.center:
            world[position.$1][position.$2] = '${prefix}3';
          case TilePos.side:
            _blastAtom(position, playerOne);
            break;
          case TilePos.corner:
            break;
        }
        break;
      case '3':
      case '-3':
        _blastAtom(position, playerOne);
        break;
    }
    setState(() {
      if (recursive) {
        return;
      }
      _playerOne = !_playerOne;
    });
  }

  Future<void> _blastAtom((int, int) position, bool playerOne) async {
    world[position.$1][position.$2] = '0';
    loading = true;
    await Future.delayed(const Duration(milliseconds: 150));
    loading = false;

    // TOP
    if (_checkInBounds((position.$1 - 1, position.$2))) {
      _selectTile((position.$1 - 1, position.$2), true, playerOne);
    }
    // BOTTOM
    if (_checkInBounds((position.$1 + 1, position.$2))) {
      _selectTile((position.$1 + 1, position.$2), true, playerOne);
    }
    // RIGHT
    if (_checkInBounds((position.$1, position.$2 + 1))) {
      _selectTile((position.$1, position.$2 + 1), true, playerOne);
    }
    // LEFT
    if (_checkInBounds((position.$1, position.$2 - 1))) {
      _selectTile((position.$1, position.$2 - 1), true, playerOne);
    }

    _checkEndGame();
  }

  bool _checkInBounds((int, int) position) {
    if (position.$1 < 0 || position.$2 < 0) {
      return false;
    }
    if (position.$1 > totalTiles.$1 - 1 || position.$2 > totalTiles.$2 - 1) {
      return false;
    }
    return true;
  }

  TilePos _getTilePos((int, int) position) {
    if (position.$1 == 0) {
      if (position.$2 == 0 || position.$2 == (totalTiles.$2 - 1)) {
        return TilePos.corner;
      }
      return TilePos.side;
    }
    if (position.$1 == (totalTiles.$1 - 1)) {
      if (position.$2 == 0 || position.$2 == (totalTiles.$2 - 1)) {
        return TilePos.corner;
      }
      return TilePos.side;
    }

    if (position.$2 == 0) {
      if (position.$1 == 0 || position.$1 == (totalTiles.$1 - 1)) {
        return TilePos.corner;
      }
      return TilePos.side;
    }
    if (position.$2 == (totalTiles.$2 - 1)) {
      if (position.$1 == 0 || position.$1 == (totalTiles.$1 - 1)) {
        return TilePos.corner;
      }
      return TilePos.side;
    }
    return TilePos.center;
  }

  void _checkEndGame() {
    int countOne = 0;
    int countTwo = 0;

    for (var row in world) {
      for (var tile in row) {
        if (tile == '0') {
          continue;
        }
        if (tile.contains('-')) {
          countTwo++;
        } else {
          countOne++;
        }
      }
    }

    setState(() {
      if (countTwo == 0) {
        _winner = true;
      } else if (countOne == 0) {
        _winner = false;
      }
    });
  }

  void restartGame() {
    world = [];
    for (int i = 0; i < totalTiles.$1; i++) {
      world.add([]);
      for (int j = 0; j < totalTiles.$2; j++) {
        world[i].add('0');
      }
    }
    setState(() {
      _winner = null;
      _playerOne = true;
      loading = false;
    });
  }

  Widget showAtom(String value) {
    switch (value) {
      case '1':
        return _singleAtom();
      case '-1':
        return _singleAtom2();
      case '2':
        return _doubleAtom();
      case '-2':
        return _doubleAtom2();
      case '3':
        return _threeAtom();
      case '-3':
        return _threeAtom2();
      default:
        return const SizedBox.shrink();
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
              child: _winner != null
                  ? SizedBox(
                      child: IconButton(
                        iconSize: _iconSize,
                        icon: const Icon(Icons.replay_rounded),
                        onPressed: restartGame,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  _winner != null
                      ? 'Player ${_winner == true ? 1 : 2} won'
                      : 'Atom Reaction',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Arial'),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_playerOne ? 'Player 1' : 'Player 2'),
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
    final count = world[position.$1][position.$2];
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (loading || _winner != null) {
            return;
          }
          _selectTile(position, false, _playerOne);
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: showAtom(count),
          ),
        ),
      ),
    );
  }

  Container _singleAtom() => Container(
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        width: 20,
      );

  Container _singleAtom2() => Container(
        decoration:
            const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        width: 20,
      );

  SizedBox _doubleAtom() => SizedBox(
        width: 30,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                width: 20,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                width: 20,
              ),
            ),
          ],
        ),
      );

  SizedBox _doubleAtom2() => SizedBox(
        width: 30,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                width: 20,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                width: 20,
              ),
            ),
          ],
        ),
      );

  SizedBox _threeAtom() => SizedBox(
        width: 30,
        height: 30,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                width: 20,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                width: 20,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                height: 20,
              ),
            ),
          ],
        ),
      );

  SizedBox _threeAtom2() => SizedBox(
        width: 30,
        height: 30,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                width: 20,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                width: 20,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                height: 20,
              ),
            ),
          ],
        ),
      );
}
