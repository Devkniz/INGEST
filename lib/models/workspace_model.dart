class Workspace {
  final String id;
  final String name;
  final List<String> boardIds;
    int membersCount; 

  Workspace({required this.id, required this.name, required this.boardIds, this.membersCount = 0});

  factory Workspace.fromJson(Map<String, dynamic> json)
   {
    return Workspace(
      id: json['id'],
      name: json['name'],
      boardIds: json['idBoards']?.cast<String>() ?? [],
      membersCount: json['members'] != null ? json['members'].length : 0,
    );
  }

@override
  String toString() {
    return 'Workspace{name: $name, id: $id}';
  }
}

