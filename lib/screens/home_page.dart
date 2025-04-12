import 'package:flutter/material.dart';
import 'workspace_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenue"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Accéder à mes Workspaces"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WorkspacePage()),
            );
          },
        ),
      ),
    );
  }
}
