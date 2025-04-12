import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/models/workspace_model.dart';
import 'package:untitled/services/trello_service.dart';
import 'trello_service_get_workspace_test.mocks.dart';


@GenerateMocks([TrelloService], customMocks: [MockSpec<Workspace>()])
void main() {
  group('TrelloService Tests', () {
    final mockService = MockTrelloService();

    test('getAllWorkspace retourne une liste de Workspaces', () async {
      // Préparer le mock pour retourner une liste spécifique
      when(mockService.getAllWorkspace()).thenAnswer(
        (_) async => [
          Workspace(id: 'id1', name: 'Workspace 1', boardIds: []),
          Workspace(id: 'id2', name: 'Workspace 2', boardIds: []),
        ],
      );

      // Appeler la méthode mockée
      final result = await mockService.getAllWorkspace();

      // Vérifiez les attentes
      expect(result.length, 2); // Deux éléments attendus
      expect(result[0].name, 'Workspace 1');
      expect(result[1].name, 'Workspace 2');
    });

    test('getAllWorkspace retourne une liste vide', () async {
      // Préparer un mock pour retourner une liste vide
      when(mockService.getAllWorkspace()).thenAnswer((_) async => []);

      // Appeler la méthode mockée
      final result = await mockService.getAllWorkspace();

      // Vérifiez que la liste est vide
      expect(result, []);
    });
  });
}
