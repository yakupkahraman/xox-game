import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XoX',
      theme: ThemeData.dark(useMaterial3: true)
          .copyWith(scaffoldBackgroundColor: _backThemeColor),
      home: const XoxGame(),
    );
  }
}

Color _backThemeColor = Color(0xff53607f);

class XoxGame extends StatefulWidget {
  const XoxGame({super.key});

  @override
  State<XoxGame> createState() => _XoxGameState();
}

class _XoxGameState extends State<XoxGame> with SingleTickerProviderStateMixin {
  List<String> board = List.filled(9, "");
  String currentPlayer = "X";
  String winner = "";
  final Color _backColor = Colors.deepOrangeAccent;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void hideGameOverScreen() {
    _controller.reverse().then((_) {
      setState(() {
        board = List.filled(9, "");
        currentPlayer = "X";
        winner = "";
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (board[index] != "" || winner != "") {
      return;
    }
    setState(() {
      board[index] = currentPlayer;
      if (_checkWinner()) {
        winner = "$currentPlayer won!";
        _controller.forward();
      } else if (!board.contains("")) {
        winner = "Berabere!";
        _controller.forward();
      } else {
        currentPlayer = currentPlayer == "X" ? "O" : "X";
      }
    });
  }

  bool _checkWinner() {
    const winningCombos = [
      [0, 1, 2], // Top row
      [3, 4, 5], // Middle row
      [6, 7, 8], // Bottom row
      [0, 3, 6], // Left column
      [1, 4, 7], // Middle column
      [2, 5, 8], // Right column
      [0, 4, 8], // Crosswise
      [2, 4, 6], // Crosswise
    ];

    for (var combo in winningCombos) {
      if (board[combo[0]] == currentPlayer &&
          board[combo[1]] == currentPlayer &&
          board[combo[2]] == currentPlayer) {
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'XoX',
          style: TextStyle(
            fontFamily: 'MoiraiOne',
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: const Color.fromARGB(255, 187, 220, 247),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80.0,
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: 9,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Card(
                        color: _backColor,
                        child: Center(
                          child: Text(
                            board[index],
                            style: const TextStyle(
                                fontFamily: 'MoiraiOne',
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ));
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(_backColor)),
                onPressed: _resetGame,
                child: Text(
                  'Restart',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          if (winner.isNotEmpty)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: child,
                );
              },
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 10, right: 20, left: 20),
                        decoration: BoxDecoration(
                          color: _backThemeColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              winner,
                              style: TextStyle(
                                fontFamily: 'MoiraiOne',
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(_backColor)),
                              onPressed: () {
                                hideGameOverScreen();
                              },
                              child: Text(
                                'Restart',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
