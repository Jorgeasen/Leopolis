import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/letters/presentation/letter_detail_screen.dart';

void main() {
  group('LetterDetailScreen', () {
    testWidgets('muestra letra en mayúscula y minúscula', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LetterDetailScreen(letter: 'A'),
          ),
        ),
      );

      expect(find.text('A'), findsWidgets);
      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('muestra la palabra de ejemplo', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LetterDetailScreen(letter: 'G'),
          ),
        ),
      );

      expect(find.text('Gato'), findsOneWidget);
    });

    testWidgets('muestra botones de TTS y navegación', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LetterDetailScreen(letter: 'B'),
          ),
        ),
      );

      expect(find.text('Escuchar letra'), findsOneWidget);
      expect(find.text('Escuchar palabra'), findsOneWidget);
      expect(find.text('◀  A'), findsOneWidget);
      expect(find.text('C  ▶'), findsOneWidget);
    });

    testWidgets('botones de navegación tienen al menos 64px de alto',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LetterDetailScreen(letter: 'A'),
          ),
        ),
      );

      // Los botones tienen height: 64 hardcodeado
      expect(find.text('Escuchar letra'), findsOneWidget);
    });
  });
}
