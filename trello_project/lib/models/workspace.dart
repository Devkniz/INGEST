class Workspace {
  final String id;
  final String name;
  final String displayName; // Champ nécessaire

  Workspace({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'],
      name: json['name'],
      displayName: json.containsKey('displayName') 
          ? json['displayName'] ?? 'Nom Indéfini' 
          : 'Nom Indéfini',
    );
  }
}
