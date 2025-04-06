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
      setState(() {
        _workspaces = workspaces ?? [];
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur: $e");
      setState(() {
        _isLoading = false;
      });
    }
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
          : ListView.builder(
              itemCount: _workspaces.length,
              itemBuilder: (context, index) {
                final workspace = _workspaces[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.work, color: Colors.green),
                    title: Text(workspace.name),
                    subtitle: Text("ID: ${workspace.id}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BoardsPage(workspaceId: workspace.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
