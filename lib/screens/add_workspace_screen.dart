import 'package:flutter/material.dart';
import 'package:trello_project/services/api_service.dart';

class AddWorkspaceScreen extends StatefulWidget {
  final TrelloApiService trelloService;

  const AddWorkspaceScreen({super.key, required this.trelloService});

  @override
  State<AddWorkspaceScreen> createState() => _AddWorkspaceScreenState();
}

class _AddWorkspaceScreenState extends State<AddWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await widget.trelloService.createWorkspace(_name, _description);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace créé avec succès !')),
        );
        Navigator.of(context).pop(); // Fermer l’écran
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Workspace'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom du workspace'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
