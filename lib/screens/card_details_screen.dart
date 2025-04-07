// FILE: lib/screens/card_details_screen.dart
import 'package:flutter/material.dart';
import '../models/card.dart';
import '../services/trello_service.dart';
import 'add_card_screen.dart';

class CardDetailsScreen extends StatefulWidget {
  final String listId;

  const CardDetailsScreen({super.key, required this.listId});

  @override
  _CardDetailsScreenState createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  List<TrelloCard> _cards = [];
  bool _isLoading = true;
  final TrelloService _trelloService = TrelloService();

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    try {
      final cards = await _trelloService.fetchCards(widget.listId);
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cartes de la liste")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newCard = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddCardScreen(listId: widget.listId),
            ),
          );
          if (newCard != null) {
            setState(() {
              _cards.add(newCard); // Ajoutez la nouvelle carte directement
            });
          }
        },
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cards.isEmpty
              ? Center(child: Text("Aucune carte trouvée"))
              : ListView.builder(
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return ListTile(
                      title: Text(card.name),
                      subtitle: Text(card.desc.isNotEmpty ? card.desc : "Pas de description"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.people),
                            onPressed: () => _showManageMembersDialog(card),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showUpdateCardDialog(card),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _confirmDeleteCard(card.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _showManageMembersDialog(TrelloCard card) async {
    try {
      final members = await _trelloService.getCardMembers(card.id); // Récupérez les membres de la carte
      showModalBottomSheet(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Gérer les membres', style: Theme.of(context).textTheme.titleLarge),
                  Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final isAssigned = card.members.any((m) => m.id == member.id);

                        return ListTile(
                          title: Text(member.fullName),
                          subtitle: Text(member.username),
                          trailing: isAssigned
                              ? IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () async {
                                    await _trelloService.removeMemberFromCard(card.id, member.id);
                                    setState(() {
                                      card.members.removeWhere((m) => m.id == member.id);
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.add_circle, color: Colors.green),
                                  onPressed: () async {
                                    await _trelloService.assignMemberToCard(card.id, member.id);
                                    setState(() {
                                      card.members.add(member);
                                    });
                                  },
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } catch (e) {
      print("Erreur lors du chargement des membres : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des membres")),
      );
    }
  }

  void _showUpdateCardDialog(TrelloCard card) {
    final TextEditingController nameController = TextEditingController(text: card.name);
    final TextEditingController descController = TextEditingController(text: card.desc);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier la Carte"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final newDesc = descController.text.trim();
              if (newName.isNotEmpty) {
                _updateCard(card.id, newName, newDesc);
                Navigator.pop(context);
              }
            },
            child: Text("Modifier"),
          ),
        ],
      ),
    );
  }

  void _updateCard(String cardId, String newName, String newDesc) async {
    try {
      await _trelloService.updateCard(cardId, newName, newDesc);
      _fetchCards(); // Rechargez les cartes après la mise à jour
    } catch (e) {
      print("Erreur lors de la mise à jour de la carte : $e");
    }
  }

  void _confirmDeleteCard(String cardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer la Carte"),
        content: Text("Êtes-vous sûr de vouloir supprimer cette carte ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              _deleteCard(cardId);
              Navigator.pop(context);
            },
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void _deleteCard(String cardId) async {
    try {
      await _trelloService.deleteCard(cardId);
      _fetchCards(); // Rechargez les cartes après la suppression
    } catch (e) {
      print("Erreur lors de la suppression de la carte : $e");
    }
  }
}
