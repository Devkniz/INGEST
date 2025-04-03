import 'package:flutter/material.dart';
import 'services/trello_service.dart';
import 'models/board.dart';
import 'package:untitled/models/trello_app.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TrelloService _trelloService = TrelloService();
  List<Board> _boards = [];
  bool _isLoading = true;
  
  get trello_api => null;

  @override
  void initState() {
    super.initState();
    _fetchBoards();
    _fetchWorkspaces();
  }

  /// Récupération des espaces de travail
  Future<void> _fetchWorkspaces() async {
    try {
      final List<dynamic>? workspaces = await trello_api.getAllWorkspace();
      print("Workspaces récupérés: $workspaces");
    } catch (e) {
      print("Erreur lors de la récupération des workspaces: $e");
    }
  }

  /// Récupération des boards
  Future<void> _fetchBoards() async {
    try {
      List<Board> boards = await _trelloService.fetchBoards();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Scaffold(
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
              : _boards.isEmpty
              ? Center(
            child: Text(
              "Aucun board trouvé",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.all(10),
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
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // TODO: Naviguer vers le détail du board
                    print("Board sélectionné: ${_boards[index].name}");
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Ajouter un board
            print("Ajouter un board");
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
