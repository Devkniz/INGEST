import 'package:flutter/material.dart';
import '../services/trello_service.dart';
import 'boards_page.dart';

class WorkspacePage extends StatefulWidget {
  @override
  _WorkspacePageState createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  List<dynamic> _workspaces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkspaces();
  }

  Future<void> _fetchWorkspaces() async {
    try {
      final workspaces = await TrelloService.getAllWorkspace();
      print("Workspaces récupérés : $workspaces");
      setState(() {
        _workspaces = workspaces ?? [];
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur lors du chargement des workspaces : $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createWorkspace(String name) async {
    try {
      final workspace = await TrelloService().createWorkspace(name);
      setState(() {
        _workspaces.add(workspace);
      });
      print("Workspace créé : ${workspace.name}");
    } catch (e) {
      print("Erreur lors de la création du workspace : $e");
    }
  }

  void _updateWorkspace(String workspaceId, String newName) async {
    try {
      await TrelloService().updateWorkspace(workspaceId, newName);
      setState(() {
        final index = _workspaces.indexWhere((w) => w.id == workspaceId);
        if (index != -1) _workspaces[index].name = newName;
      });
      print("Workspace mis à jour : $newName");
    } catch (e) {
      print("Erreur lors de la mise à jour : $e");
    }
  }

  void _deleteWorkspace(String workspaceId) async {
    try {
      await TrelloService().deleteWorkspace(workspaceId);
      setState(() {
        _workspaces.removeWhere((w) => w.id == workspaceId);
      });
      print("Workspace supprimé : $workspaceId");
    } catch (e) {
      print("Erreur lors de la suppression : $e");
    }
  }

  void _confirmDeleteWorkspace(String workspaceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer le Workspace"),
        content: Text("Êtes-vous sûr de vouloir supprimer ce workspace ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              _deleteWorkspace(workspaceId);
              Navigator.pop(context);
            },
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void _showCreateWorkspaceDialog() {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Créer un Workspace"),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: "Nom du Workspace"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                _createWorkspace(name);
                Navigator.pop(context);
              }
            },
            child: Text("Créer"),
          ),
        ],
      ),
    );
  }

  void _showUpdateWorkspaceDialog(String workspaceId, String currentName) {
    final TextEditingController _nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier le Workspace"),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: "Nouveau nom"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              final newName = _nameController.text.trim();
              if (newName.isNotEmpty) {
                _updateWorkspace(workspaceId, newName);
                Navigator.pop(context);
              }
            },
            child: Text("Modifier"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workspaces"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _workspaces.isEmpty
              ? Center(child: Text("Aucun workspace trouvé"))
              : ListView.builder(
                  itemCount: _workspaces.length,
                  itemBuilder: (context, index) {
                    final workspace = _workspaces[index];
                    return ListTile(
                      title: Text(workspace.name),
                      subtitle: Text("ID: ${workspace.id}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showUpdateWorkspaceDialog(workspace.id, workspace.name),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDeleteWorkspace(workspace.id),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BoardsPage(workspaceId: workspace.id),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showCreateWorkspaceDialog,
      ),
    );
  }
}
