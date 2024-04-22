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

  void selectTile((int, int) position) {}

  void restartGame() {}

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

  Expanded _tile((int, int) position) => Expanded(
        child: GestureDetector(
          onTap: () {
            selectTile(position);
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: const Center(
              child: Text('a'),
            ),
          ),
        ),
      );
}
