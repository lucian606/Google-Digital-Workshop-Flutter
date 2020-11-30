import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

bool gameOver(List<int> gameMatrix, int player) {
  for (int i = 0; i <= 2; i++) {
    if (gameMatrix[i] == player &&
        gameMatrix[i + 3] == player &&
        gameMatrix[i + 6] == player) {
      for (int j = 0; j <= 2; j++) {
        if (j != i) {
          gameMatrix[j] = 0;
          gameMatrix[j + 3] = 0;
          gameMatrix[j + 6] = 0;
        }
      }
      return true;
    }
  } //check win on column
  for (int i = 0; i <= 6; i += 3) {
    if (gameMatrix[i] == player &&
        gameMatrix[i + 1] == player &&
        gameMatrix[i + 2] == player) {
      for (int j = 0; j <= 6; j += 3) {
        if (j != i) {
          gameMatrix[j] = 0;
          gameMatrix[j + 1] = 0;
          gameMatrix[j + 2] = 0;
        }
      }
      return true;
    }
  } //check win on row
  if (gameMatrix[0] == player &&
      gameMatrix[4] == player &&
      gameMatrix[8] == player) {
    gameMatrix[1] = 0;
    gameMatrix[2] = 0;
    gameMatrix[3] = 0;
    gameMatrix[5] = 0;
    gameMatrix[6] = 0;
    gameMatrix[7] = 0;
    return true;
  } //check win on main diagonal

  if (gameMatrix[2] == player &&
      gameMatrix[4] == player &&
      gameMatrix[6] == player) {
    gameMatrix[0] = 0;
    gameMatrix[1] = 0;
    gameMatrix[3] = 0;
    gameMatrix[5] = 0;
    gameMatrix[7] = 0;
    gameMatrix[8] = 0;
    return true;
  } //check win on secondary diagonal

  return false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Tic-Tac-Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> gameMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<dynamic> playerColors = <dynamic>[
    Colors.white,
    Colors.orange,
    Colors.purple
  ];
  int currentPlayer = 1;
  bool gameGoing = true;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      decoration: BoxDecoration(
                        color: playerColors[gameMatrix[index]],
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (gameMatrix[index] == 0 && gameGoing) {
                          gameMatrix[index] = currentPlayer;
                          gameGoing = !gameOver(gameMatrix, currentPlayer);
                          currentPlayer = currentPlayer == 1 ? 2 : 1;
                          if (gameMatrix
                              .where((int element) => element == 0)
                              .isEmpty) {
                            gameGoing = false;
                          }
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Visibility(
                visible: !gameGoing,
                child: ElevatedButton(
                onPressed: () {
                setState(() {
                  if (!gameGoing) {
                    gameMatrix = gameMatrix.map((int x) => 0).toList();
                    currentPlayer = 1;
                    gameGoing = true;
                  }});
                } ,
                child: Text("Play Again!"),
            )),
          ],
        ));
  }
}
