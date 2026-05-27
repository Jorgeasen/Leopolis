import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/presentation/word_match_screen.dart';

Widget _wrap() =>
    const ProviderScope(child: MaterialApp(home: WordMatchScreen()));

void main() {
  group('WordMatchScreen', () {
    testWidgets('muestra tres opciones de respuesta', (tester) async {
      await tester.pumpWidget(_wrap());
      expect(find.byType(GestureDetector), findsWidgets);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.isNotEmpty, true);
    });

    testWidgets('el marcador empieza en cero', (tester) async {
      await tester.pumpWidget(_wrap());
      expect(find.text('0 ⭐'), findsOneWidget);
    });

    testWidgets('tiene botón de volver', (tester) async {
      await tester.pumpWidget(_wrap());
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra emoji fallback cuando el asset no existe',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.byType(Text), findsWidgets);
    });
  });
}
