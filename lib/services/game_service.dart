import 'package:tournament/repositories/repository.dart';
import 'package:tournament/models/game.dart';

class GameService {
  Repository _repository;

  GameService() {
    _repository = Repository();
  }

  //add a game
  saveGame(Game game) async {
    return await _repository.insertData('games', game.gameMap());
  }

  //read games
  readGames() async {
    return await _repository.readData('games');
  }

  // Delete data from table
  deleteGame(gameId) async {
    return await _repository.deleteData('games', gameId);
  }
}
