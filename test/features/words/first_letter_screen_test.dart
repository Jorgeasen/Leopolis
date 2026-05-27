import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/presentation/first_letter_screen.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => null,
    );
  });

  group('FirstLetterScreen', () {
    testWidgets('muestra progreso de ronda y botón de volver', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FirstLetterScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Ronda 0 / 10'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra instrucción y tarjeta de palabra', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FirstLetterScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('¿Con qué letra empieza?'), findsOneWidget);
      expect(find.text('Toca para escuchar'), findsOneWidget);
    });

    testWidgets('muestra 4 opciones de letra', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FirstLetterScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(GridView), findsOneWidget);
      // 4 letter buttons inside the grid
      final gridFinder = find.byType(GridView);
      final buttonsInGrid = find.descendant(
        of: gridFinder,
        matching: find.byType(GestureDetector),
      );
      expect(tester.widgetList(buttonsInGrid).length, equals(4));
    });
  });
}
