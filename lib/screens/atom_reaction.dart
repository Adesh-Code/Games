import 'package:flutter/material.dart';

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

  void selectTile((int, int) position) {}

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
  SafeArea build(BuildContext context) {
    return SafeArea(
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
          selectTile(position);
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

  Widget _singleAtom() => Container();
  Widget _doubleAtom() => Container();
  Widget _threeAtom() => Container();
}
