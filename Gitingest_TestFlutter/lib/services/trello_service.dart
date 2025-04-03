import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:untitled/widgets/board_item.dart';
import '../models/board.dart';
import '../models/list.dart';
import '../models/card.dart';
import '../utils/constants.dart';


class TrelloService {

  final _baseUrl = 'https://api.trello.com/1';

  Future<List<Board>> fetchBoards() async {
    final url = '$_baseUrl/members/me/boards?key=$trelloApikey&token=$trelloToken';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((board) => Board.fromJson(board)).toList();
    } else {
      throw Exception('Erreur lors du chargement des Boards');

    }
  }


  Future<List<TrelloList>> fetchLists (String listId) async {
    final url = '$_baseUrl /lists/listsId/cards?key=$trelloApikey&token=$trelloToken';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((list) => TrelloList.fromJson(list)).toList();
    } else {
      throw Exception('Erreur lors de chargement des list');
    }
  }
  Future<List<TrelloCard>> fectchCards (String listId) async{
    final url = '$_baseUrl/lists/$listId/cards?key=$trelloApikey&token=$trelloToken';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((card) => TrelloCard.fromJson(card)).toList();
    } else {
      throw Exception('Erreur lors du chargement des cartes');
    }
  }
}


