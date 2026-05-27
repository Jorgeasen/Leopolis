import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/presentation/rhyme_check_screen.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => null,
    );
  });

  group('RhymeCheckScreen', () {
    testWidgets('muestra progreso de ronda y botón de volver', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RhymeCheckScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text('Ronda 0 / 10'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra instrucción y dos palabras lado a lado',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RhymeCheckScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text('¿Riman estas palabras?'), findsOneWidget);
      expect(find.text('Toca para escuchar'), findsOneWidget);
    });

    testWidgets('muestra botones Si riman y No riman', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RhymeCheckScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text('✓ ¡Sí riman!'), findsOneWidget);
      expect(find.text('✗ No riman'), findsOneWidget);
    });
  });
}
