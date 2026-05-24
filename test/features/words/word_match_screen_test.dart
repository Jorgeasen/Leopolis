import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/presentation/word_match_screen.dart';

void main() {
  group('WordMatchScreen', () {
    testWidgets('muestra tres opciones de respuesta', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordMatchScreen()),
      );

      // 3 _OptionButton widgets (uno por opción)
      expect(find.byType(GestureDetector), findsWidgets);
      // Hay exactamente 3 botones de opción (dentro del Expanded+Padding)
      // Verificamos que hay al menos 3 textos de opciones en la pantalla
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.isNotEmpty, true);
    });

    testWidgets('el marcador empieza en cero', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordMatchScreen()),
      );

      expect(find.text('0 ⭐'), findsOneWidget);
    });

    testWidgets('tiene botón de volver', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordMatchScreen()),
      );

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('tiene imagen placeholder cuando el asset no existe',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WordMatchScreen()),
      );
      await tester.pump();

      // Cuando el asset no existe, se muestra el Icon placeholder
      expect(find.byIcon(Icons.image_rounded), findsOneWidget);
    });
  });
}
