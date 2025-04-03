
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/models/card.dart' as member_model;
import 'package:untitled/widgets/board_item.dart';
import '../models/board.dart';
import '../models/list.dart';
import '../models/Workspace.dart';



class TrelloService {

  static final _baseUrl = 'https://api.trello.com/1';
  static const String api_key = '52613835b6318e879731aabf730dae33';
  static const String token = 'ATTA2ee944c2cecab0594e304f0edb8540551727a9ec17f4a98e46617f0bdcbd5bfeD28540EC';


  static Future<List<Board>> getAllWorkspace() async {
  final url = '_baseUrl/members/me/organizations?key=api_key&token=token';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);

    return data.map((board) => Board.fromJson(board)).toList();
  } else {
    throw Exception('Erreur lors du chargement des Boards ${response.statusCode}');
  }
}

  addCard(String listId, String text, String text2) {}

  fetchLists(String boardId) {}

  fectchCards(String listId) {}

  fetchBoards() {}
}


Future<Workspace> createWorkspace(String name) async {
  final url = '_baseUrl/organizations?key=api_key&token=token';
  final response = await http.post(
    Uri.parse(url),
    body: {
      'displayName': name,
      'name': name,
    },
  );

  if (response.statusCode == 200) {
    return Workspace.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erreur lors de la création de l\'espace de travail');
  }
}

Future<void> deleteWorkspace(String workspaceId) async {
  final url = '_baseUrl/organizations/$workspaceId?key=api_key&token=token';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Erreur lors de la suppression de l\'espace de travail');
  }
}

Future<void> updateWorkspace(String workspaceId, String newName) async {
  final url = '_baseUrl/organizations/$workspaceId?key=api_key&token=token';
  final response = await http.put(
    Uri.parse(url),
    body: {
      'displayName': newName,
      'name': newName,
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Erreur lors de la mise à jour de l\'espace de travail');
  }
}


Future<List<member_model.Member>> getMembers(String workspaceId) async {
  final url = '_baseUrl/organizations/$workspaceId/members?key=api_key&token=token';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((member) => member_model.Member.fromJson(member)).toList();
  } else {
    throw Exception('Erreur lors du chargement des membres');
  }
}


Future<List<member_model.Member>> creatMembers(
    String workspaceId, String fullName, String username, String email) async {
  final url = '_baseUrl/organizations/$workspaceId/members?key=api_key&token=token';
  final response = await http.post(
    Uri.parse(url),
    body: {
      'fullName': fullName,
      'username': username,
      'email': email,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((member) => member_model.Member.fromJson(member)).toList();
  } else {
    throw Exception('Erreur lors de la création des membres');
  }
}

Future<List<member_model.Member>> deleteMembers(
    String workspaceId, String memberId) async {
  final url = '_baseUrl/organizations/$workspaceId/members/$memberId?key=api_key&token=token';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((member) => member_model.Member.fromJson(member)).toList();
  } else {
    throw Exception('Erreur lors de la suppression des membres');
  }
}

Future<List<member_model.Member>> updateMembers(
    String workspaceId, String memberId, String newName) async {
  final url = '_baseUrl/organizations/$workspaceId/members/$memberId?key=api_key&token=token';
  final response = await http.put(
    Uri.parse(url),
    body: {
      'fullName': newName,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((member) => member_model.Member.fromJson(member)).toList();
  } else {
    throw Exception('Erreur lors de la mise à jour des membres');
  }
}



Future<List<TrelloList>> getAllLists(String boardId) async {
  final url = '_baseUrl/boards/$boardId/lists?key=api_key&token=token';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((ist) => TrelloList.fromJson(TrelloList as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Erreur lors du chargement des listes');
  }
}

Future<List<TrelloList>> createList(
    String boardId, String name) async {
  final url = '_baseUrl/boards/boardId/lists?key=api_key&token=token';
  final response = await http.post(
    Uri.parse(url),
    body: {
      'name': name,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((list) => TrelloList.fromJson(list)).toList();
  } else {
    throw Exception('Erreur lors de la création de la liste');
  }
}


Future<List<TrelloList>> deleteList(
    String boardId, String listId) async {
  final url = '_baseUrl/boards/$boardId/lists/$listId?key=api_key&token=token';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((list) => TrelloList.fromJson(list)).toList();
  } else {
    throw Exception('Erreur lors de la suppression de la liste');
  }
}

Future<List<TrelloList>> updateList(
    String boardId, String listId, String newName) async {
  final url = '_baseUrl/boards/$boardId/lists/$listId?key=api_key&token=token';
  final response = await http.put(
    Uri.parse(url),
    body: {
      'name': newName,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((list) => TrelloList.fromJson(list)).toList();
  } else {
    throw Exception('Erreur lors de la mise à jour de la liste');
  }
}

Future<List<member_model.TrelloCard>> getAllCards(String listId) async {
  final url = '_baseUrl/lists/$listId/cards?key=api_key&token=token';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((card) => member_model.TrelloCard.fromJson(card)).toList();
  } else {
    throw Exception('Erreur lors du chargement des cartes');
  }
}

Future<List<member_model.TrelloCard>> createCard(
    String listId, String name) async {
  final url = '_baseUrl/lists/$listId/cards?key=api_key&token=token';
  final response = await http.post(
    Uri.parse(url),
    body: {
      'name': name,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((card) => member_model.TrelloCard.fromJson(card)).toList();
  } else {
    throw Exception('Erreur lors de la création de la carte');
  }
}

Future<List<member_model.TrelloCard>> deleteCard(
    String listId, String cardId) async {
  final url = '_baseUrl/lists/$listId/cards/$cardId?key=api_key&token=token';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((card) => member_model.TrelloCard.fromJson(card)).toList();
  } else {
    throw Exception('Erreur lors de la suppression de la carte');
  }
}

Future<List<member_model.TrelloCard>> updateCard(
    String listId, String cardId, String newName) async {
  final url = '_baseUrl/lists/$listId/cards/$cardId?key=api_key&token=token';
  final response = await http.put(
    Uri.parse(url),
    body: {
      'name': newName,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((card) => member_model.TrelloCard.fromJson(card)).toList();
  } else {
    throw Exception('Erreur lors de la mise à jour de la carte');
  }
}

Future<List<Board>> getAllBoards() async {
  final url = '_baseUrl/members/me/boards?key=api_key&token=token';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((board) => Board.fromJson(board)).toList();
  } else {
    throw Exception('Erreur lors du chargement des Boards');
  }
}

Future<List<Board>> createBoard(String name) async {
  final url = '_baseUrl/boards?key=api_key&token=token';
  final response = await http.post(
    Uri.parse(url),
    body: {
      'name': name,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((board) => Board.fromJson(board)).toList();
  } else {
    throw Exception('Erreur lors de la création du Board');
  }
}

Future<List<Board>> deleteBoard(String boardId) async {
  final url = '_baseUrl/boards/$boardId?key=api_key&token=token';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((board) => Board.fromJson(board)).toList();
  } else {
    throw Exception('Erreur lors de la suppression du Board');
  }
}

Future<List<Board>> updateBoard(String boardId, String newName) async {
  final url = '_baseUrl/boards/$boardId?key=api_key&token=token';
  final response = await http.put(
    Uri.parse(url),
    body: {
      'name': newName,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((board) => Board.fromJson(board)).toList();
  } else {
    throw Exception('Erreur lors de la mise à jour du Board');
  }
}




