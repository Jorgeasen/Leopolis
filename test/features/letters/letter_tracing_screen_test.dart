import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/letters/presentation/letter_tracing_screen.dart';
import 'package:leopolis/shared/widgets/tracing_canvas.dart';

void main() {
  group('LetterTracingScreen', () {
    testWidgets('muestra instrucción y canvas', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LetterTracingScreen(letter: 'A'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Traza la letra 🖊️'), findsOneWidget);
      expect(find.byType(TracingCanvas), findsOneWidget);
    });

    testWidgets('botón volver está visible', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LetterTracingScreen(letter: 'B'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });
  });

  group('TracingCanvas', () {
    testWidgets('muestra el widget correctamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TracingCanvas(
              letter: 'A',
              canvasSize: const Size(280, 280),
              onSuccess: () {},
              onFailure: () {},
            ),
          ),
        ),
      );

      expect(find.byType(TracingCanvas), findsOneWidget);
      expect(find.text('Borrar'), findsOneWidget);
    });
  });
}
