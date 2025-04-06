import 'package:flutter/material.dart';
import '../services/trello_service.dart';
import '../models/board.dart';
import '../models/workspace.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> _boards = [];
  List<dynamic> _workspaces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBoards();
    _fetchWorkspaces();
  }

  Future<void> _fetchWorkspaces() async {
    try {
      final List<dynamic>? workspaces = await TrelloService.getAllWorkspace();
      setState(() {
        _workspaces = workspaces ?? [];
      });
    } catch (e) {
      print("Erreur lors de la récupération des workspaces: $e");
    }
  }

  Future<void> _fetchBoards() async {
    try {
      List<dynamic> boards = await TrelloService.getAllBoards();
      setState(() {
        _boards = boards;
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
        title: Text('Trello Boards'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (_workspaces.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Workspaces",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _workspaces.length,
                        itemBuilder: (context, index) {
                          final workspace = _workspaces[index];
                          return Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.work, color: Colors.green),
                              title: Text(
                                workspace.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("ID: ${workspace.id}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BoardCreationScreen(workspaceId: workspace.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (_boards.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Trello Boards",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _boards.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.dashboard, color: Colors.blueAccent),
                              title: Text(
                                _boards[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("ID: ${_boards[index].id}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class BoardCreationScreen extends StatefulWidget {
  final String workspaceId;

  BoardCreationScreen({required this.workspaceId});

  @override
  _BoardCreationScreenState createState() => _BoardCreationScreenState();
}

class _BoardCreationScreenState extends State<BoardCreationScreen> {
  final TextEditingController _boardNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createBoard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final boardName = _boardNameController.text.trim();
      if (boardName.isNotEmpty) {
        await TrelloService.createBoard(boardName, widget.workspaceId);
        Navigator.pop(context);
      }
    } catch (e) {
      print("Erreur lors de la création du board: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un Board"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _boardNameController,
              decoration: InputDecoration(labelText: "Nom du Board"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createBoard,
                    child: Text("Créer"),
                  ),
          ],
        ),
      ),
    );
  }
}
