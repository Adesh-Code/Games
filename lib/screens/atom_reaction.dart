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
  bool gameEnd = false;
  List<List<int>> world = [];

  @override
  void initState() {
    super.initState();
    generateWorld();
  }

  void generateWorld() {
    for (int i = 0; i < totalTiles.$1; i++) {
      world.add([]);
      for (int j = 0; j < totalTiles.$2; j++) {
        world[i].add(0);
      }
    }
  }

  void _selectTile((int, int) position) {
    switch (world[position.$1][position.$2]) {
      case 0:
        world[position.$1][position.$2] = 1;
      case 1:
        switch (_getTilePos(position)) {
          case TilePos.center:
          case TilePos.side:
            world[position.$1][position.$2] = 2;
            break;
          case TilePos.corner:
            _blastAtom(position);
            break;
        }
        break;
      case 2:
        switch (_getTilePos(position)) {
          case TilePos.center:
            world[position.$1][position.$2] = 3;
          case TilePos.side:
            _blastAtom(position);
            break;
          case TilePos.corner:
            break;
        }
        break;
      case 3:
        _blastAtom(position);
        break;
    }
    setState(() {});
  }

  _blastAtom((int, int) position) {
    world[position.$1][position.$2] = 0;
    // TOP
    if (_checkInBounds((position.$1 - 1, position.$2))) {
      _selectTile((position.$1 - 1, position.$2));
    }
    // BOTTOM
    if (_checkInBounds((position.$1 + 1, position.$2))) {
      _selectTile((position.$1 + 1, position.$2));
    }
    // RIGHT
    if (_checkInBounds((position.$1, position.$2 + 1))) {
      _selectTile((position.$1, position.$2 + 1));
    }
    // LEFT
    if (_checkInBounds((position.$1, position.$2 - 1))) {
      _selectTile((position.$1, position.$2 - 1));
    }
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
    return TilePos.center;
  }

  void restartGame() {}

  Widget showAtom(int count) {
    switch (count) {
      case 1:
        return _singleAtom();
      case 2:
        return _doubleAtom();
      case 3:
        return _threeAtom();
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
                  'Atom Reaction',
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
    final count = world[position.$1][position.$2];
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _selectTile(position);
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

  Widget _singleAtom() => Container(
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        width: 20,
      );

  Widget _doubleAtom() => SizedBox(
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

  Widget _threeAtom() => SizedBox(
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
}
