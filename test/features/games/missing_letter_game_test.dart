import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/games/presentation/missing_letter_game.dart';

void main() {
  group('MissingLetterGame', () {
    testWidgets('muestra el contador en cero', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MissingLetterGame()),
      );
      expect(find.text('0 ✓'), findsOneWidget);
    });

    testWidgets('muestra botón de volver', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MissingLetterGame()),
      );
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra el hueco con guion bajo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MissingLetterGame()),
      );
      await tester.pump();
      expect(find.text('_'), findsOneWidget);
    });

    testWidgets('muestra 4 opciones de letra', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MissingLetterGame()),
      );
      await tester.pump();
      final count = tester.widgetList(find.byType(GestureDetector)).length;
      expect(count, greaterThanOrEqualTo(4));
    });

    testWidgets('muestra imagen placeholder cuando el asset no existe',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MissingLetterGame()),
      );
      await tester.pump();
      expect(find.byIcon(Icons.image_rounded), findsOneWidget);
    });
  });
}
