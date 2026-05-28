import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/presentation/syllable_build_screen.dart';

void main() {
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (call) async => null,
    );
  });

  testWidgets('SyllableBuildScreen muestra progreso y botón de volver',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SyllableBuildScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('0 / 8'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
  });

  testWidgets('SyllableBuildScreen muestra slots y sílabas disponibles',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SyllableBuildScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // Should have syllable tiles available (the word's syllables shuffled)
    expect(find.byType(GestureDetector), findsWidgets);
  });
}
