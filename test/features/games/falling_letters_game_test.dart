import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/games/presentation/falling_letters_game.dart';

void main() {
  group('FallingLettersGame', () {
    testWidgets('muestra el marcador de estrellas en cero', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: FallingLettersGame()),
      );
      expect(find.text('⭐ 0'), findsOneWidget);
    });

    testWidgets('muestra botón de pausa', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: FallingLettersGame()),
      );
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });

    testWidgets('muestra botón de volver', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: FallingLettersGame()),
      );
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra la burbuja con la letra objetivo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: FallingLettersGame()),
      );
      expect(find.text('Toca la: '), findsOneWidget);
    });
  });
}
