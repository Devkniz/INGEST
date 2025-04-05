import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trello_project/models/workspace.dart'; // Modèle Workspace
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TrelloApiService {
  final String baseUrl = "https://api.trello.com/1";

  Future<List<Workspace>> getWorkspaces() async {
    try {
      // Debug: Affiche les clés récupérées du fichier .env
      final String? apiKey = dotenv.env['TRELLO_API_KEY'];
      final String? apiToken = dotenv.env['TRELLO_API_TOKEN'];

      print("API Key: $apiKey");
      print("API Token: $apiToken");

      if (apiKey == null || apiToken == null) {
        throw Exception(
            "Les clés d'API (TRELLO_API_KEY et/ou TRELLO_API_TOKEN) sont manquantes. Vérifie le fichier .env.");
      }

      // Construction de l'URL
      final url = Uri.parse("$baseUrl/members/me/organizations?key=$apiKey&token=$apiToken");
      print("Request URL: $url");

      // Envoie la requête HTTP GET
      final response = await http.get(url);

      // Debug : Affiche le statut HTTP et le body de la réponse
      print("HTTP Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("Parsed Data: $data"); // Debug : Affiche les données JSON parsées
        return data.map((json) => Workspace.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception(
            "Erreur HTTP 401 : Unauthorized. Vérifie tes clés d'API ou ton token.");
      } else {
        throw Exception("Erreur HTTP ${response.statusCode} : ${response.body}");
      }
    } catch (e) {
      print("Une erreur est survenue dans getWorkspaces : $e");
      throw Exception("Erreur dans getWorkspaces : $e");
    }
  }
}
