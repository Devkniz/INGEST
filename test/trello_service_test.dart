import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/services/trello_service.dart';
import 'package:untitled/models/Workspace.dart';
import 'trello_service_test.mocks.dart';

@GenerateMocks([TrelloService])
void main() {
  group('TrelloService Tests', () {
    test('should return workspaces when fetching from API', () async {
      // Créer une instance de MockTrelloService
      final mockService = MockTrelloService();

      // Définir le comportement du mock
      when(mockService.getAllWorkspace()).thenAnswer((_) async => [
            Workspace(
              id: 'workspace1',
              name: 'Test Workspace',
            ),
          ]);

      // Appel de la méthode
      final workspaces = await mockService.getAllWorkspace();

      // Vérification des résultats
      expect(workspaces.length, 1);
      expect(workspaces[0].name, 'Test Workspace');
    });
  });
}
