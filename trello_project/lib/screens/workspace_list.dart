import 'package:flutter/material.dart';
import 'package:trello_project/services/api_service.dart';
import 'package:trello_project/models/workspace.dart';

class WorkspaceListScreen extends StatefulWidget {
  const WorkspaceListScreen({Key? key}) : super(key: key);

  @override
  _WorkspaceListScreenState createState() => _WorkspaceListScreenState();
}

class _WorkspaceListScreenState extends State<WorkspaceListScreen> {
  late Future<List<Workspace>> futureWorkspaces;

  @override
  void initState() {
    super.initState();
    futureWorkspaces = TrelloApiService().getWorkspaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspaces'),
      ),
      body: FutureBuilder<List<Workspace>>(
        future: futureWorkspaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final workspaces = snapshot.data!;
            return ListView.builder(
              itemCount: workspaces.length,
              itemBuilder: (context, index) {
                final workspace = workspaces[index];
                return ListTile(
                  title: Text(workspace.displayName),
                  subtitle: Text('ID : ${workspace.id}'),
                  onTap: () {
                    // Ajoute une navigation ici si nécessaire
                    print('Workspace sélectionné : ${workspace.displayName}');
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('Aucun workspace disponible'),
            );
          }
        },
      ),
    );
  }
}
