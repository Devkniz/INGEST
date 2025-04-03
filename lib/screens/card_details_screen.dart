import 'package:flutter/material.dart';
import '../models/card.dart';
import '../services/trello_service.dart';

class CardDetailsScreen extends StatefulWidget {
  final String listId;
  CardDetailsScreen({required this.listId});

  @override
  _CardDetailsScreenState createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final TrelloService _trelloService = TrelloService();
  List<TrelloCard> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    try {
      List<TrelloCard> cards = await _trelloService.fectchCards(widget.listId);
      setState(() {
        _cards = cards;
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
      appBar: AppBar(title: Text("Cartes de la Liste")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return ListTile(
            title: Text(card.name),
            subtitle: Text(card.desc),
          );
        },
      ),
    );
  }
}
