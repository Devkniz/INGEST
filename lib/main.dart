import 'package:flutter/material.dart';
import 'services/trello_service.dart';
import 'models/board.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchBoards();
  }

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
      home: Scaffold(
        appBar: AppBar(title: Text('Test API Trello')),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _boards.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_boards[index].name),
              subtitle: Text(_boards[index].id),
            );
          },
        ),
      ),
    );
  }
}
