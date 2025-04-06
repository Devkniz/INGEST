import 'package:flutter/material.dart';
import '../models/board.dart';
import '../services/trello_service.dart';

class BoardsPage extends StatefulWidget {
  final String workspaceId;

  BoardsPage({required this.workspaceId});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Boards du Workspace')),
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
                      subtitle: Text("ID: ${board.id}"),
                    );
                  },
                ),
    );
  }
}
