import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/models/card.dart' as member_model;
import '../models/board.dart';
import '../models/list.dart';
import '../models/Workspace.dart';
import '../models/card.dart';

class TrelloService {
  static final _baseUrl = 'https://api.trello.com/1';
  static const String api_key = '52613835b6318e879731aabf730dae33';
  static const String token =
      'ATTA2ee944c2cecab0594e304f0edb8540551727a9ec17f4a98e46617f0bdcbd5bfeD28540EC';

  Future<List<Workspace>> getAllWorkspace() async {
    final url = '$_baseUrl/members/me/organizations?key=$api_key&token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((json) => Workspace.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des workspaces");
    }
  }

  addCard(String listId, String text, String text2) {}

  fetchLists(String boardId) {}

  fectchCards(String listId) {}

  fetchBoards() {}

  Future<Workspace> createWorkspace(String name) async {
    final url = '$_baseUrl/organizations?key=$api_key&token=$token';
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
    final url = '$_baseUrl/organizations/$workspaceId?key=api_key&token=$token';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression de l\'espace de travail');
    }
  }

  Future<void> updateWorkspace(String workspaceId, String newName) async {
    final url =
        '$_baseUrl/organizations/$workspaceId?key=$api_key&token=$token';
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
    final url =
        '$_baseUrl/organizations/$workspaceId/members?$api_key&token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((member) => member_model.Member.fromJson(member))
          .toList();
    } else {
      throw Exception('Erreur lors du chargement des membres');
    }
  }

  Future<List<member_model.Member>> createMembers(String workspaceId,
      String fullName, String username, String email) async {
    final url =
        '$_baseUrl/organizations/$workspaceId/members?key=$api_key&token=$token';
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
      return data
          .map((member) => member_model.Member.fromJson(member))
          .toList();
    } else {
      throw Exception('Erreur lors de la création des membres');
    }
  }

  Future<List<member_model.Member>> deleteMembers(
      String workspaceId, String memberId) async {
    final url =
        '$_baseUrl/organizations/$workspaceId/members/$memberId?key=$api_key&token=$token';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((member) => member_model.Member.fromJson(member))
          .toList();
    } else {
      throw Exception('Erreur lors de la suppression des membres');
    }
  }

  Future<List<member_model.Member>> updateMembers(
      String workspaceId, String memberId, String newName) async {
    final url =
        '$_baseUrl/organizations/$workspaceId/members/$memberId?key=$api_key&token=$token';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'fullName': newName,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((member) => member_model.Member.fromJson(member))
          .toList();
    } else {
      throw Exception('Erreur lors de la mise à jour des membres');
    }
  }

 
  Future<List<TrelloList>> getAllLists(String boardId) async {
  final url = '$_baseUrl/boards/$boardId/lists?key=$api_key&token=$token';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data as List).map((json) => TrelloList.fromJson(json)).toList();
  } else {
    throw Exception("Erreur lors du chargement des listes");
  }
}


  Future<TrelloList> createList(String boardId, String name) async {
    final url = '$_baseUrl/boards/$boardId/lists?key=$api_key&token=$token';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      print("Liste créée avec succès");
      return TrelloList.fromJson(data); // Retournez une seule liste
    } else {
      print("Erreur lors de la création de la liste: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la création de la liste");
    }
  }

  Future<void> deleteList(String boardId, String listId) async {
    final url = '$_baseUrl/boards/$boardId/lists/$listId?key=$api_key&token=$token';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Liste supprimée avec succès");
    } else {
      print("Erreur lors de la suppression de la liste: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la suppression de la liste");
    }
  }

  Future<void> updateList(String listId, String newName) async {
    final url = '$_baseUrl/lists/$listId?key=$api_key&token=$token';
    print("URL: $url");
    print("Nouveau nom : $newName");

    final response = await http.put(
      Uri.parse(url),
      body: {
        'name': newName,
      },
    );

    print("Statut de la réponse : ${response.statusCode}");
    print("Corps de la réponse : ${response.body}");

    if (response.statusCode == 200) {
      print("Liste mise à jour avec succès");
    } else {
      print("Erreur lors de la mise à jour de la liste: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la mise à jour de la liste");
    }
  }

  Future<void> updateListById(String listId, String newName) async {
    final url = '$_baseUrl/lists/$listId?key=$api_key&token=$token';
    print("URL: $url");
    print("Nouveau nom : $newName");

    final response = await http.put(
      Uri.parse(url),
      body: {
        'name': newName,
      },
    );

    print("Statut de la réponse : ${response.statusCode}");
    print("Corps de la réponse : ${response.body}");

    if (response.statusCode == 200) {
      print("Liste mise à jour avec succès");
    } else {
      print("Erreur lors de la mise à jour de la liste: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la mise à jour de la liste");
    }
  }

  Future<void> archiveList(String listId) async {
    final url = '$_baseUrl/lists/$listId?key=$api_key&token=$token';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'closed': 'true',
      },
    );

    if (response.statusCode == 200) {
      print("Liste archivée avec succès");
    } else {
      print("Erreur lors de l'archivage de la liste : ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de l'archivage de la liste");
    }
  }

  Future<List<member_model.TrelloCard>> getAllCards(String listId) async {
    final url = '$_baseUrl/lists/$listId/cards?key=$api_key&token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((card) => member_model.TrelloCard.fromJson(card))
          .toList();
    } else {
      throw Exception('Erreur lors du chargement des cartes');
    }
  }

  Future<List<TrelloCard>> fetchCards(String listId) async {
    final url = '$_baseUrl/lists/$listId/cards?key=$api_key&token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((json) => TrelloCard.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des cartes");
    }
  }

  Future<List<member_model.TrelloCard>> createCardForList(
      String listId, String name) async {
    final url = '$_baseUrl/lists/$listId/cards?key=$api_key&token=$token';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((card) => member_model.TrelloCard.fromJson(card))
          .toList();
    } else {
      throw Exception('Erreur lors de la création de la carte');
    }
  }

  Future<TrelloCard> createCard(String listId, String name, String desc) async {
    final url = '$_baseUrl/cards?key=$api_key&token=$token';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'desc': desc,
        'idList': listId,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      print("Carte créée avec succès");
      return TrelloCard.fromJson(data);
    } else {
      print("Erreur lors de la création de la carte: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la création de la carte");
    }
  }

  Future<List<member_model.TrelloCard>> deleteCardFromList(
      String listId, String cardId) async {
    final url =
        '$_baseUrl/lists/$listId/cards/$cardId?key=$api_key&token=$token';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((card) => member_model.TrelloCard.fromJson(card))
          .toList();
    } else {
      throw Exception('Erreur lors de la suppression de la carte');
    }
  }

  Future<void> deleteCard(String cardId) async {
  // This method remains unchanged
    final url = '$_baseUrl/cards/$cardId?key=$api_key&token=$token';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Carte supprimée avec succès");
    } else {
      print("Erreur lors de la suppression de la carte: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la suppression de la carte");
    }
  }

  Future<List<member_model.TrelloCard>> updateCardInList(
      String listId, String cardId, String newName) async {
    final url =
        '$_baseUrl/lists/$listId/cards/$cardId?key=$api_key&token=$token';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'name': newName,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((card) => member_model.TrelloCard.fromJson(card))
          .toList();
    } else {
      throw Exception('Erreur lors de la mise à jour de la carte');
    }
  }

  Future<void> updateCard(String cardId, String newName, String newDesc) async {
    final url = '$_baseUrl/cards/$cardId?key=$api_key&token=$token';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'name': newName,
        'desc': newDesc,
      },
    );

    if (response.statusCode == 200) {
      print("Carte mise à jour avec succès");
    } else {
      print("Erreur lors de la mise à jour de la carte: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la mise à jour de la carte");
    }
  }

  Future<void> assignMemberToCard(String cardId, String memberId) async {
    final url = '$_baseUrl/cards/$cardId/idMembers?key=$api_key&token=$token';
    print("URL: $url");
    print("Membre à assigner : $memberId");

    final response = await http.post(
      Uri.parse(url),
      body: {
        'value': memberId,
      },
    );

    print("Statut de la réponse : ${response.statusCode}");
    print("Corps de la réponse : ${response.body}");

    if (response.statusCode == 200) {
      print("Membre assigné avec succès à la carte");
    } else {
      print("Erreur lors de l'assignation du membre : ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de l'assignation du membre");
    }
  }

  Future<void> removeMemberFromCard(String cardId, String memberId) async {
    final url = '$_baseUrl/cards/$cardId/idMembers/$memberId?key=$api_key&token=$token';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Membre supprimé avec succès de la carte");
    } else {
      print("Erreur lors de la suppression du membre : ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la suppression du membre");
    }
  }

  Future<List<Board>> getAllBoards() async {
    final url = '$_baseUrl/members/me/boards?key=$api_key&token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((json) => Board.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des boards : ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> createBoard(String name, String workspaceId) async {
    final url = '$_baseUrl/boards?key=$api_key&token=$token';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'idOrganization': workspaceId,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Board créé avec succès");
    } else {
      print("Erreur lors de la création du board : ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la création du board");
    }
  }

  Future<void> deleteBoard(String boardId) async {
    final url = '$_baseUrl/boards/$boardId?key=$api_key&token=$token';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Board supprimé avec succès");
    } else {
      print("Erreur lors de la suppression du board: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la suppression du board");
    }
  }

  Future<void> updateBoard(String boardId, String newName) async {
    final url = '$_baseUrl/boards/$boardId?key=$api_key&token=$token';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'name': newName,
      },
    );

    if (response.statusCode == 200) {
      print("Board mis à jour avec succès");
    } else {
      print("Erreur lors de la mise à jour du board: ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors de la mise à jour du board");
    }
  }

  Future<List<Member>> getCardMembers(String cardId) async {
    final url = '$_baseUrl/cards/$cardId/members?key=$api_key&token=$token';
    print("URL: $url");

    final response = await http.get(Uri.parse(url));

    print("Statut de la réponse : ${response.statusCode}");
    print("Corps de la réponse : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((json) => Member.fromJson(json)).toList();
    } else {
      print("Erreur lors du chargement des membres : ${response.statusCode} - ${response.body}");
      throw Exception("Erreur lors du chargement des membres");
    }
  }

  Future<List<Member>> getCardMembersById(String cardId) async {
    final url = '$_baseUrl/cards/$cardId/members?key=$api_key&token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((json) => Member.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des membres");
    }
  }

  Future<void> createKanbanTemplate(String boardName, String workspaceId) async {
    // Étape 1 : Créez le tableau
    final boardUrl = '$_baseUrl/boards?key=$api_key&token=$token';
    final boardResponse = await http.post(
      Uri.parse(boardUrl),
      body: {
        'name': boardName,
        'idOrganization': workspaceId,
      },
    );

    if (boardResponse.statusCode == 200 || boardResponse.statusCode == 201) {
      final boardData = json.decode(boardResponse.body);
      final boardId = boardData['id'];
      print("Tableau créé avec succès : $boardId");

      // Étape 2 : Ajoutez les listes par défaut
      final defaultLists = ['À faire', 'En cours', 'Terminé'];
      final defaultCards = {
        'À faire': ['Tâche 1', 'Tâche 2'],
        'En cours': ['Tâche 3'],
        'Terminé': ['Tâche 4'],
      };

      for (String listName in defaultLists) {
        // Créez la liste
        final listUrl = '$_baseUrl/boards/$boardId/lists?key=$api_key&token=$token';
        final listResponse = await http.post(
          Uri.parse(listUrl),
          body: {
            'name': listName,
          },
        );

        if (listResponse.statusCode == 200 || listResponse.statusCode == 201) {
          final listData = json.decode(listResponse.body);
          final listId = listData['id'];

          // Ajoutez les cartes par défaut
          if (defaultCards.containsKey(listName)) {
            for (String cardName in defaultCards[listName]!) {
              final cardUrl = '$_baseUrl/cards?key=$api_key&token=$token';
              await http.post(
                Uri.parse(cardUrl),
                body: {
                  'name': cardName,
                  'idList': listId,
                },
              );
            }
          }
        } else {
          print("Erreur lors de l'ajout de la liste '$listName': ${listResponse.statusCode} - ${listResponse.body}");
        }
      }
    } else {
      print("Erreur lors de la création du tableau : ${boardResponse.statusCode} - ${boardResponse.body}");
      throw Exception("Erreur lors de la création du tableau");
    }
  }
}
