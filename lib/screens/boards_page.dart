import 'package:flutter/material.dart';
import 'package:untitled/screens/lists_page.dart';
import '../services/trello_service.dart';

class BoardsPage extends StatefulWidget {
  final String workspaceId;

  const BoardsPage({super.key, required this.workspaceId});

  @override
  _BoardsPageState createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  List<dynamic> _boards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBoards();
  }

  Future<void> _fetchBoards() async {
    try {
      final allBoards = await TrelloService.getAllBoards();

      final filteredBoards = allBoards
          .where((board) => board.idOrganization == widget.workspaceId)
          .toList();

      setState(() {
        _boards = filteredBoards;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCreateBoardDialog() {
    final TextEditingController nameController = TextEditingController();
    String boardType = 'Simple'; // Par défaut, le type est "Simple"

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Créer un Board"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nom du Board"),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: boardType,
              items: [
                DropdownMenuItem(value: 'Simple', child: Text("Simple")),
                DropdownMenuItem(value: 'Kanban', child: Text("Kanban")),
              ],
              onChanged: (value) {
                boardType = value!;
              },
              decoration: InputDecoration(labelText: "Type de Board"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                if (boardType == 'Kanban') {
                  _createKanbanBoard(name);
                } else {
                  _createSimpleBoard(name);
                }
                Navigator.pop(context);
              }
            },
            child: Text("Créer"),
          ),
        ],
      ),
    );
  }

  void _createSimpleBoard(String name) async {
    try {
      await TrelloService().createBoard(name, widget.workspaceId);
      _fetchBoards(); // Rechargez les boards après la création
    } catch (e) {
      print("Erreur lors de la création du board simple : $e");
    }
  }

  void _createKanbanBoard(String name) async {
    try {
      await TrelloService().createKanbanTemplate(name, widget.workspaceId);
      _fetchBoards(); // Rechargez les boards après la création
    } catch (e) {
      print("Erreur lors de la création du tableau Kanban : $e");
    }
  }

  void _showUpdateBoardDialog(String boardId, String currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier le Board"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: "Nouveau nom"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                _updateBoard(boardId, newName);
                Navigator.pop(context);
              }
            },
            child: Text("Modifier"),
          ),
        ],
      ),
    );
  }

  void _updateBoard(String boardId, String newName) async {
    try {
      await TrelloService().updateBoard(boardId, newName);
      _fetchBoards(); // Rechargez les boards après la mise à jour
    } catch (e) {
      print("Erreur lors de la mise à jour du board : $e");
    }
  }

  void _showCreateKanbanDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Créer un tableau Kanban"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: "Nom du tableau Kanban"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                _createKanbanBoard(name);
                Navigator.pop(context);
              }
            },
            child: Text("Créer"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBoard(String boardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer le Board"),
        content: Text("Êtes-vous sûr de vouloir supprimer ce board ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              _deleteBoard(boardId);
              Navigator.pop(context);
            },
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void _deleteBoard(String boardId) async {
    try {
      await TrelloService().deleteBoard(boardId);
      _fetchBoards(); // Rechargez les boards après la suppression
    } catch (e) {
      print("Erreur lors de la suppression du board : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards du Workspace'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateBoardDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _boards.isEmpty
              ? Center(child: Text("Aucun board trouvé pour ce workspace"))
              : ListView.builder(
                  itemCount: _boards.length,
                  itemBuilder: (context, index) {
                    final board = _boards[index];
                    return ListTile(
                      title: Text(board.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showUpdateBoardDialog(board.id, board.name),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDeleteBoard(board.id),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListsPage(boardId: board.id),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateKanbanDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
