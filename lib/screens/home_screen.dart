import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/boards_page.dart';
import '../providers/trello_provider.dart';
import 'boards_page.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TrelloProvider>(context, listen: false).loadBoards();
  }

  @override
  Widget build(BuildContext context) {
    final trelloProvider = Provider.of<TrelloProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Mes Boards Trello")),
      body: trelloProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: trelloProvider.boards.length,
        itemBuilder: (context, index) {
          final board = trelloProvider.boards[index];
          return ListTile(
            title: Text(board.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoardsPage(workspaceId: board.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
