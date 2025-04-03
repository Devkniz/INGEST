import 'package:flutter/material.dart';
import '../models/board.dart';
import '../services/trello_service.dart';

class TrelloProvider with ChangeNotifier {
  final TrelloService _trelloService = TrelloService();
  List<Board> _boards = [];
  bool _isLoading = false;

  List<Board> get boards => _boards;
  bool get isLoading => _isLoading;

  Future<void> loadBoards() async {
    _isLoading = true;
    notifyListeners();

    _boards = await _trelloService.fetchBoards();

    _isLoading = false;
    notifyListeners();
  }
}
