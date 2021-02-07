import 'package:flutter/material.dart';
import 'package:tournament/models/game.dart';
import 'package:tournament/services/game_service.dart';
import 'package:tournament/data/game_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _score1Controller = TextEditingController();
  var _score2Controller = TextEditingController();

  //var _editCategoryNameController = TextEditingController();
  //var _editCategoryDescriptionController = TextEditingController();

  var _game = Game();
  var _gameService = GameService();

  bool formValid = true;

  List<Game> _gameList = List<Game>();

  var _roundValue = '3';

  var _player1Value;
  var _player2Value;

  var _players = List<DropdownMenuItem>();
  var _rounds = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    getAllGames();
    _loadPlayers();
    _loadRounds();

    _score1Controller.text = '';
    _score2Controller.text = '';
  }

  getAllGames() async {
    print("call list");
    var _gameListAll = List<Game>();

    var games = await _gameService.readGames();
    games.forEach((game) {
      var gameModel = Game();
      gameModel.id = game['id'];
      gameModel.roundId = game['roundId'];
      gameModel.player1 = game['player1'];
      gameModel.player2 = game['player2'];
      gameModel.score1 = game['score1'];
      gameModel.score2 = game['score2'];

      _gameListAll.add(gameModel);
    });

    setState(() {
      _gameList = _gameListAll;
    });

    print(_gameList.length);
  }

  _loadPlayers() {
    GaneData.playerList.forEach((player) {
      print(player);
      _players.add(DropdownMenuItem(
        child: Text(player),
        value: player,
      ));
    });
  }

  _loadRounds() {
    GaneData.roundList.forEach((round) {
      _rounds.add(DropdownMenuItem(
        child: Text(round),
        value: round,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build is called");
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Tournament Control',
          style: TextStyle(
            fontSize: 30.0,
          ),
        )),
      ),
      body: ListView.builder(
          itemCount: _gameList.length,
          itemBuilder: (context, index) {
            var line1 =
                _gameList[index].player1 + ' vs ' + _gameList[index].player2;
            var line2 =
                _gameList[index].score1 + ' : ' + _gameList[index].score2;
            var roundLine = _gameList[index].roundId;

            return Padding(
              padding: EdgeInsets.only(
                  top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: Card(
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ListTile(
                    leading: Text(
                      '$roundLine',
                      style: TextStyle(fontSize: 35.0, color: Colors.blue),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "$line1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 20.0),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              //print(_gameList[index].id);
                              _deleteFormDialog(context, _gameList[index].id);
                            })
                      ],
                    ),
                    subtitle: Text(
                      "$line2",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  bool validateGame(Game game) {
    var result = true;
    if (game.player1 == null ||
        game.player2 == null ||
        game.score1 == '' ||
        game.score2 == '') {
      result = false;
    } else {
      if (game.player1 == game.player2) {
        result = false;
      }
    }
    return result;
  }

  _addFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () {
                  _player1Value = null;
                  _player2Value = null;
                  _roundValue = '3';
                  _score1Controller.text = '';
                  _score2Controller.text = '';

                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () async {
                  print(_roundValue);
                  _game.roundId = _roundValue;
                  _game.player1 = _player1Value;
                  _game.player2 = _player2Value;
                  _game.score1 = _score1Controller.text;
                  _game.score2 = _score2Controller.text;

                  var result = 0;
                  formValid = validateGame(_game);

                  if (formValid) {
                    result = await _gameService.saveGame(_game);
                  }

                  if (result > 0) {
                    print(result);
                    _score1Controller.text = '';
                    _score2Controller.text = '';

                    _player1Value = null;
                    _player2Value = null;
                    _roundValue = '3';

                    Navigator.pop(context);

                    getAllGames();
                  } else {
                    print("error");
                  }
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add New Result'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField(
                    value: _roundValue,
                    items: _rounds,
                    hint: Text("Round"),
                    onChanged: (value) {
                      setState(() {
                        _roundValue = value;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    value: _player1Value,
                    items: _players,
                    hint: Text("Team 1"),
                    onChanged: (value) {
                      setState(() {
                        _player1Value = value;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    value: _player1Value,
                    items: _players,
                    hint: Text("Team 2"),
                    onChanged: (value) {
                      setState(() {
                        _player2Value = value;
                      });
                    },
                  ),
                  TextField(
                    controller: _score1Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Player 1 score', labelText: 'Score 1'),
                  ),
                  TextField(
                    controller: _score2Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Player 2 score', labelText: 'Score 2'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, gameId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () async {
                  var result = await _gameService.deleteGame(gameId);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllGames();
                  }
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Are you sure you want to delete this?'),
          );
        });
  }
}
