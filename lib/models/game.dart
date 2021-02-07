class Game {
  int id;
  String roundId;
  String player1;
  String player2;
  String score1;
  String score2;

  gameMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['roundId'] = roundId;
    mapping['player1'] = player1;
    mapping['player2'] = player2;
    mapping['score1'] = score1;
    mapping['score2'] = score2;

    return mapping;
  }
}
