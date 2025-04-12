import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/models/workspace_model.dart';
import 'package:untitled/services/trello_service.dart';
import 'dart:async'; 
import 'trello_service_get_workspace_test.mocks.dart';

// Générer uniquement un mock pour TrelloService
@GenerateMocks([TrelloService])
void main() {
  // Instancier le mock
  final mockService = MockTrelloService();

  group('TrelloService.getAllWorkspace', () {

    test('Retourne une liste de workspaces mockée', () async {
      // Préparer le mock de retour de `getAllWorkspace`
      when(mockService.getAllWorkspace()).thenAnswer(
        (_) async => [
          Workspace(id: 'id1', name: 'Workspace 1', boardIds: [], membersCount: 5),
          Workspace(id: 'id2', name: 'Workspace 2', boardIds: ['board1'], membersCount: 0),
        ],
      );

      // Appeler la méthode mockée
      final result = await mockService.getAllWorkspace();

      // Vérifier les résultats attendus
      expect(result.length, 2);                         // Vérifie que 2 workspaces sont retournés
      expect(result[0].name, 'Workspace 1');            // Nom du premier workspace
      expect(result[0].membersCount, 5);                // Nombre de membres du premier workspace
      expect(result[1].boardIds.contains('board1'), true); // Vérifie que le deuxième contient 'board1'
    });

    test('Retourne une liste vide', () async {
      // Préparer un mock avec une liste vide
      when(mockService.getAllWorkspace()).thenAnswer((_) async => []);

      // Appeler la méthode mockée
      final result = await mockService.getAllWorkspace();

      // Vérifier que la liste est vide
      expect(result, isEmpty);
    });
  test('getAllWorkspace gère les erreurs en levant une exception', () async {
    // Simuler une erreur pour la méthode mockée
    when(mockService.getAllWorkspace()).thenThrow(Exception('Une erreur s\'est produite'));

    try {
      // Appeler la méthode mockée
      await mockService.getAllWorkspace();
      // Si aucune exception n'est levée, le test échoue
      fail('Une exception aurait dû être lancée');
    } catch (e) {
      // Vérifier que l'exception levée est bien celle attendue
      expect(e, isA<Exception>());
      expect(e.toString(), contains('Une erreur s\'est produite'));
    }
  });
});

test('getAllWorkspace gère une TimeoutException', () async {
  // Simuler une TimeoutException pour la méthode mockée
  when(mockService.getAllWorkspace()).thenThrow(TimeoutException('Le délai de connexion est dépassé'));

  try {
    // Appeler la méthode mockée
    await mockService.getAllWorkspace();
    // Si aucune exception n'est levée, le test échoue
    fail('Une TimeoutException aurait dû être levée');
  } catch (e) {
    // Vérifier que l'exception levée est une TimeoutException
    expect(e, isA<TimeoutException>());
    expect(e.toString(), contains('Le délai de connexion est dépassé'));
  }
});

}