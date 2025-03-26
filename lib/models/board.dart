class Board{

  final String id; // ont initialise le id
  final String name;// pareil pour le name

  Board ({required this.id, required this.name});  // ont cree un id ansi qu'un name

  factory Board.fromJson(Map<String, dynamic> json){
      return Board(
      id:json ['id'],
      name: json ['name'],
      );
  }

}