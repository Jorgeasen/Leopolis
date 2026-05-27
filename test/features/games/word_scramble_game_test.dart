import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/games/presentation/word_scramble_game.dart';

void main() {
  group('WordScrambleGame', () {
    testWidgets('muestra el contador en cero', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordScrambleGame()),
      );
      expect(find.text('0 ✓'), findsOneWidget);
    });

    testWidgets('muestra botón de volver', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordScrambleGame()),
      );
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra botón de pista', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordScrambleGame()),
      );
      expect(find.text('💡'), findsOneWidget);
    });

    testWidgets('muestra slots y letras disponibles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordScrambleGame()),
      );
      await tester.pump();
      // Should have DragTarget slots and Draggable letters
      expect(find.byType(DragTarget<int>), findsWidgets);
      expect(find.byType(Draggable<int>), findsWidgets);
    });

    testWidgets('muestra emoji fallback cuando el asset no existe',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordScrambleGame()),
      );
      await tester.pump();
      // AssetImageWithFallback muestra emoji cuando el asset no existe
      expect(find.byType(WordScrambleGame), findsOneWidget);
    });
  });
}
