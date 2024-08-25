import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GameController extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<String> _board = List.filled(9, '');
  String _currentPlayer = 'X';
  String _winner = '';
  bool _isOver = false;
  bool _isPlayingWithAI = false;
  // Getter
  List<String> get board => _board;
  String get currentPlayer => _currentPlayer;
  String get winner => _winner;
  bool get isOver => _isOver;
  bool get isAi => _isPlayingWithAI;

  // Set the mode to play with AI or another player
  void setPlayMode(bool playWithAI) {
    _isPlayingWithAI = playWithAI;
    resetGame();
  }
  // move function
  void makeMove(int index) {
    if (_board[index] == '' && !_isOver) {
      _board[index] = _currentPlayer;
      if (_checkWinner()) {
        _winner = _currentPlayer;
        _isOver = true;
        _playWinSound();
      } else if (_board.every((element) => element != '')) {
        _isOver = true;
      } else {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        if (_isPlayingWithAI && _currentPlayer == 'O') {
          _makeAIMove();
        }
      }
      notifyListeners();
    }
  }

  // AI makes a move
  void _makeAIMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isOver) return;

      int move = _findBestMove();
      makeMove(move);
    });
  }

  // Simple AI to find the best move
  int _findBestMove() {
    // Check if AI can win
    for (int i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = 'O';
        if (_checkWinner()) {
          _board[i] = '';
          return i;
        }
        _board[i] = '';
      }
    }

    // Block opponent's winning move
    for (int i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = 'X';
        if (_checkWinner()) {
          _board[i] = '';
          return i;
        }
        _board[i] = '';
      }
    }

    // Take center if available
    if (_board[4] == '') return 4;

    // Take a corner if available
    for (int i in [0, 2, 6, 8]) {
      if (_board[i] == '') return i;
    }

    // Take any empty spot
    for (int i = 0; i < 9; i++) {
      if (_board[i] == '') return i;
    }

    return -1; // Should not happen
  }

  // check winner function
  bool _checkWinner() {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var combination in winningCombinations) {
      if (_board[combination[0]] != '' &&
          _board[combination[0]] == _board[combination[1]] &&
          _board[combination[1]] == _board[combination[2]]) {
        return true;
      }
    }
    return false;
  }

  //reset function
  void resetGame() {
    _board = List.filled(9, '');
    _currentPlayer = 'X';
    _winner = '';
    _isOver = false;
    notifyListeners();
  }

  // play sound when user win
  void _playWinSound() async {
    await _audioPlayer.play(AssetSource('sound/victory.mp3'));
  }
}
