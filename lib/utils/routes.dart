import 'package:flutter/material.dart';
import 'package:trello_project/services/api_service.dart';
import '../screens/add_workspace_screen.dart';
import '../screens/workspace_list.dart';

class Routes {
  static const String home = '/';
  static const String workspaceList = '/workspace-list';
  static const String addWorkspace = '/add-workspace';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const WorkspaceListScreen());
      case Routes.addWorkspace:
        return MaterialPageRoute(
          builder:
              (_) => AddWorkspaceScreen(
                trelloService:
                    TrelloApiService(), // Fournir une instance valide de TrelloApiService
              ),
        );
      case workspaceList:
        return MaterialPageRoute(builder: (_) => const WorkspaceListScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Route non trouvée')),
              ),
        );
    }
  }
}
