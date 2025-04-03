class Board{

  final String id; // ont initialise le id
  final String name;// pareil pour le name
  int memberCount = 0; // ont initialise le memberCount a 0

  Board ({required this.id, required this.name, this.memberCount=0});  // ont cree un id ansi qu'un name

  factory Board.fromJson(Map<String, dynamic> json){
      return Board(
      id:json ['id'],
      name: json ['name'],
      memberCount: json['members'] != null ? json['membersCount'].length : 0,
      );
  }

  get membert => null;

}