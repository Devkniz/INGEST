import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/api_service.dart';
import 'package:trello_project/screens/workspace_list.dart';



void main() async {
try {
    await dotenv.load(fileName: 'assets/.env');
    print("DotEnv loaded: ${dotenv.env}");
  } catch (e) {
    print("Erreur lors du chargement du fichier .env : $e");
  }
    TrelloApiService().getWorkspaces(); // Test le fetch des workspaces
 runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Retire le bandeau ‘debug’
      title: 'Trello Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
      home: const HomePage(), // Point d’entrée, page ‘Home’
    );
  }


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue sur Trello Clone'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigue vers WorkspaceListScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkspaceListScreen(),
              ),
            );
          },
          child: const Text('Afficher les Workspaces'),
        ),
      ),
    );
  }
}



