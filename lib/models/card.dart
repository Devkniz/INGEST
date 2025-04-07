class TrelloCard {
  final String id;
  final String name;
  final String desc;
  final List<Member> members;

  TrelloCard({
    required this.id,
    required this.name,
    required this.desc,
    required this.members,
  });

  factory TrelloCard.fromJson(Map<String, dynamic> json) {
    var membersList = json['members'] as List? ?? [];
    List<Member> members = membersList.map((m) => Member.fromJson(m)).toList();

    return TrelloCard(
      id: json['id'],
      name: json['name'],
      desc: json['desc'] ?? '',
      members: members,
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
