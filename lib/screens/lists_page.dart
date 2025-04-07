import 'package:flutter/material.dart';
import '../models/list.dart';
import '../services/trello_service.dart';
import 'card_details_screen.dart';

class ListsPage extends StatefulWidget {
  final String boardId;

  const ListsPage({super.key, required this.boardId});

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<TrelloList> _lists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  Future<void> _fetchLists() async {
    try {
      print("Fetching lists for board ID: ${widget.boardId}");
      final trelloService = TrelloService();
      final lists = await trelloService.getAllLists(widget.boardId);
      setState(() {
        _lists = lists;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCreateListDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Créer une Liste"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: "Nom de la Liste"),
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
                _createList(name);
                Navigator.pop(context);
              }
            },
            child: Text("Créer"),
          ),
        ],
      ),
    );
  }

  void _createList(String name) async {
    try {
      final newList = await TrelloService().createList(widget.boardId, name);
      setState(() {
        _lists.add(newList); // Ajoutez la nouvelle liste directement
      });
      print("Liste créée : ${newList.name}");
    } catch (e) {
      print("Erreur lors de la création de la liste : $e");
    }
  }

  void _showUpdateListDialog(String listId, String currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier la Liste"),
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
                _updateList(listId, newName);
                Navigator.pop(context);
              }
            },
            child: Text("Modifier"),
          ),
        ],
      ),
    );
  }

  void _updateList(String listId, String newName) async {
    try {
      print("Mise à jour de la liste : $listId avec le nouveau nom : $newName");
      await TrelloService().updateList(listId, newName);
      _fetchLists(); // Rechargez les listes après la mise à jour
    } catch (e) {
      print("Erreur lors de la mise à jour de la liste : $e");
    }
  }

  void _confirmDeleteList(String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer la Liste"),
        content: Text("Êtes-vous sûr de vouloir supprimer cette liste ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              _deleteList(listId);
              Navigator.pop(context);
            },
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void _deleteList(String listId) async {
    try {
      print("Suppression de la liste : $listId");
      await TrelloService().archiveList(listId); // Utilisez archiveList si deleteList ne fonctionne pas
      _fetchLists();
    } catch (e) {
      print("Erreur lors de la suppression de la liste : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listes du Tableau"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateListDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _lists.isEmpty
              ? Center(child: Text("Aucune liste trouvée dans ce tableau"))
              : ListView.builder(
                  itemCount: _lists.length,
                  itemBuilder: (context, index) {
                    final list = _lists[index];
                    return ListTile(
                      title: Text(list.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showUpdateListDialog(list.id, list.name),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDeleteList(list.id),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CardDetailsScreen(listId: list.id),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateListDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
