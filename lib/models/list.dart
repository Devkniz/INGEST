import 'package:untitled/models/card.dart' as my_models;

class TrelloList {
  final String id;
  final String name;
  List<my_models.TrelloCard> cards;

  TrelloList({required this.id, required this.name, List<my_models.TrelloCard>? cards})
      : cards = cards ?? [];

  factory TrelloList.fromJson(Map<String, dynamic> json) {
    var cardsList = json['cards'] as List? ?? [];
    List<my_models.TrelloCard> cards =
        cardsList.map((cardJson) => my_models.TrelloCard.fromJson(cardJson)).toList();

    return TrelloList(
      id: json['id'],
      name: json['name'],
      cards: cards,
    );
  }
}
