class TrelloCard {
  final String id;
  final String name;
  final String desc;
  List<Member> _Members = [];

  TrelloCard ({required this.id, required this.name,required this.desc, });

  List <Member> get members => _Members;

  factory TrelloCard.fromJson(Map<String, dynamic> json) {

    return TrelloCard(

        id: json['id'],
        name: json ['name'],
        desc: json ['desc'] ?? '',
    );
  }

}

class Member {
  final String id;
  final String fullName;
  final String username;

  Member({required this.id, required this.fullName, required this.username});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
    );
  }
}