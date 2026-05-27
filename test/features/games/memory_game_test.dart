import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/games/presentation/memory_game.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => null,
    );
  });

  group('MemoryGame', () {
    testWidgets('muestra contador de pares y botón de volver', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MemoryGame(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('0 / 6 pares'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra instruccion y 12 tarjetas boca abajo', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MemoryGame(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('¡Encuentra los pares!'), findsOneWidget);
      // 12 card backs visible (each shows the leo emoji)
      expect(find.text('🦁'), findsNWidgets(12));
    });

    testWidgets('voltear una tarjeta la muestra boca arriba', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MemoryGame(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Tap the first card
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Now 11 card backs remain (one is face-up)
      expect(find.text('🦁'), findsNWidgets(11));
    });
  });
}
