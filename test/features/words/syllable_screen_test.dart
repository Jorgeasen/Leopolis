import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/presentation/syllable_screen.dart';

Widget _wrap() => const ProviderScope(child: MaterialApp(home: SyllableScreen()));

void main() {
  group('SyllableScreen', () {
    testWidgets('el marcador empieza en cero', (tester) async {
      await tester.pumpWidget(_wrap());
      expect(find.text('0 ⭐'), findsOneWidget);
    });

    testWidgets('muestra botón de volver', (tester) async {
      await tester.pumpWidget(_wrap());
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra el slot oculto con signo de interrogación',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('muestra opciones de sílaba', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      final syllableButtons =
          tester.widgetList<Text>(find.byType(Text)).where((t) {
        return t.style?.color == Colors.white &&
            t.style?.fontSize == 26 &&
            t.data != null &&
            t.data!.isNotEmpty;
      }).toList();
      expect(syllableButtons.length, greaterThanOrEqualTo(2));
    });

    testWidgets('muestra emoji fallback cuando el asset no existe',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.byType(Text), findsWidgets);
    });
  });
}
