import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/shared/widgets/leo_mascot.dart';

void main() {
  group('LeoMascot', () {
    testWidgets('muestra el emoji de leoncito', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LeoMascot())),
      );
      expect(find.text('🦁'), findsOneWidget);
    });

    testWidgets('muestra mensaje cuando se proporciona', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeoMascot(
              state: LeoState.encouraging,
              message: '¡Inténtalo otra vez!',
            ),
          ),
        ),
      );
      expect(find.text('🦁'), findsOneWidget);
      expect(find.text('¡Inténtalo otra vez!'), findsOneWidget);
    });

    testWidgets('funciona con estado celebrating', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeoMascot(state: LeoState.celebrating, size: 80),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('🦁'), findsOneWidget);
    });

    testWidgets('funciona con estado sleeping sin animación', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LeoMascot(state: LeoState.sleeping)),
        ),
      );
      expect(find.text('🦁'), findsOneWidget);
    });

    testWidgets('acepta tamaño personalizado', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LeoMascot(size: 60)),
        ),
      );
      expect(find.text('🦁'), findsOneWidget);
    });
  });
}
