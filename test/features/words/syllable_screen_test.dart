import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/presentation/syllable_screen.dart';

void main() {
  group('SyllableScreen', () {
    testWidgets('el marcador empieza en cero', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SyllableScreen()),
      );
      expect(find.text('0 ⭐'), findsOneWidget);
    });

    testWidgets('muestra botón de volver', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SyllableScreen()),
      );
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra el slot oculto con signo de interrogación',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SyllableScreen()),
      );
      await tester.pump();
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('muestra opciones de sílaba', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SyllableScreen()),
      );
      await tester.pump();
      // Debe haber al menos 2 opciones de sílaba en mayúsculas
      final syllableButtons =
          tester.widgetList<Text>(find.byType(Text)).where((t) {
        return t.style?.color == Colors.white &&
            t.style?.fontSize == 26 &&
            t.data != null &&
            t.data!.isNotEmpty;
      }).toList();
      expect(syllableButtons.length, greaterThanOrEqualTo(2));
    });

    testWidgets('tiene imagen placeholder cuando el asset no existe',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SyllableScreen()),
      );
      await tester.pump();
      expect(find.byIcon(Icons.image_rounded), findsOneWidget);
    });
  });
}
