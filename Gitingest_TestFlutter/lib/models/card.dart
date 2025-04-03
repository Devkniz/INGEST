class TrelloCard {
  final String id;
  final String name;
  final String desc;

  TrelloCard ({required this.id, required this.name,required this.desc, });

  factory TrelloCard.fromJson(Map<String, dynamic> json) {

    return TrelloCard(

        id: json['id'],
        name: json ['name'],
        desc: json ['desc'] ?? '',
    );
  }

}