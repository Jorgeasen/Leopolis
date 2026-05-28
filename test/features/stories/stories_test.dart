import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/stories/data/stories_repository.dart';
import 'package:leopolis/features/stories/data/stories_read_provider.dart';
import 'package:leopolis/features/stories/presentation/stories_screen.dart';
import 'package:leopolis/features/stories/presentation/story_reader_screen.dart';

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

  group('StoriesRepository', () {
    test('getAll devuelve 4 cuentos', () {
      expect(StoriesRepository.getAll().length, 4);
    });

    test('getById devuelve el cuento correcto', () {
      final story = StoriesRepository.getById('gato_raton');
      expect(story, isNotNull);
      expect(story!.titulo, 'El gato y el ratón');
      expect(story.paginas.length, 6);
    });

    test('getById devuelve null para id desconocido', () {
      expect(StoriesRepository.getById('no_existe'), isNull);
    });

    test('cada cuento tiene al menos 5 páginas', () {
      for (final story in StoriesRepository.getAll()) {
        expect(story.paginas.length, greaterThanOrEqualTo(5),
            reason: 'Cuento ${story.id} tiene pocas páginas');
      }
    });
  });

  group('StoriesReadNotifier', () {
    test('marca un cuento como leído', () {
      final notifier = StoriesReadNotifier();
      expect(notifier.state, isEmpty);
      notifier.markRead('gato_raton');
      expect(notifier.state, contains('gato_raton'));
    });

    test('no duplica entradas', () {
      final notifier = StoriesReadNotifier();
      notifier.markRead('gato_raton');
      notifier.markRead('gato_raton');
      expect(notifier.state.length, 1);
    });
  });

  testWidgets('StoriesScreen muestra lista de cuentos y botón volver',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: StoriesScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('El gato y el ratón'), findsOneWidget);
    expect(find.text('La casa de Leo'), findsOneWidget);
  });

  testWidgets('StoryReaderScreen muestra primera página y controles',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: StoryReaderScreen(storyId: 'gato_raton'),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    expect(find.text('Página 1 de 6'), findsOneWidget);
  });

  testWidgets('StoryReaderScreen muestra pantalla de error para id inválido',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: StoryReaderScreen(storyId: 'no_existe'),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('¡Vamos a intentarlo otra vez! 🦁'), findsOneWidget);
  });
}
