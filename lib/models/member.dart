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