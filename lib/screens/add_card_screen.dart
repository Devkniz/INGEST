import 'package:flutter/material.dart';
import '../services/trello_service.dart';

class AddCardScreen extends StatefulWidget {
  final String listId;

  AddCardScreen({required this.listId});

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TrelloService _trelloService = TrelloService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _addCard() async {
    if (_nameController.text.isEmpty) return;

    try {
      await _trelloService.addCard(
        widget.listId,
        _nameController.text,
        _descController.text,
      );
      Navigator.pop(context, true); // Retour avec succès
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout de la carte")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une carte")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nom de la carte"),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCard,
              child: Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}
