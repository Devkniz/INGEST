import 'package:flutter/material.dart';
import '../models/list.dart';
import '../services/trello_service.dart';
import 'card_details_screen.dart';

class BoardScreen extends StatefulWidget {
  final String boardId;
  BoardScreen({required this.boardId});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final TrelloService _trelloService = TrelloService();
  List<TrelloList> _lists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  Future<void> _fetchLists() async {
    try {
      List<TrelloList> lists = await _trelloService.fetchLists(widget.boardId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listes du Board")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _lists.length,
        itemBuilder: (context, index) {
          final list = _lists[index];
          return ListTile(
            title: Text(list.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardDetailsScreen(listId: list.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
