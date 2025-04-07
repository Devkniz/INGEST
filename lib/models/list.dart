import 'package:untitled/models/card.dart' as my_models;

class TrelloList {
  final String id;
  final String name;

  TrelloList({required this.id, required this.name});

  factory TrelloList.fromJson(Map<String, dynamic> json) {
    return TrelloList(
      id: json['id'],
      name: json['name'],
    );
  }
}
