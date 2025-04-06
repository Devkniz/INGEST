import 'package:flutter/material.dart';
import '../models/list.dart';
import '../services/trello_service.dart';
import 'card_details_screen.dart';

class ListsPage extends StatefulWidget {
  final String boardId;

  const ListsPage({Key? key, required this.boardId}) : super(key: key);

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
      final trelloService =
          TrelloService(); // Crée une instance de TrelloService
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listes du Tableau")),
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
    );
  }
}
