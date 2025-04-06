class Board {
  final String id;
  final String name;
  final String idOrganization;

  Board({required this.id, required this.name, required this.idOrganization});

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      name: json['name'],
      idOrganization: json['idOrganization'] ?? '',
    );
  }
}
