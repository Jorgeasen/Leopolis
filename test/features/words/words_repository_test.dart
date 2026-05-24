import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/data/word_data.dart';
import 'package:leopolis/features/words/data/words_repository.dart';

void main() {
  group('WordsRepository', () {
    test('getAll returns at least 30 words', () {
      expect(WordsRepository.getAll().length, greaterThanOrEqualTo(30));
    });

    test('getAll contains level 1 and level 2 words', () {
      final words = WordsRepository.getAll();
      expect(words.any((w) => w.nivelDificultad == 1), true);
      expect(words.any((w) => w.nivelDificultad == 2), true);
    });

    test('getByLevel returns only words of requested level', () {
      final level1 = WordsRepository.getByLevel(1);
      expect(level1.every((w) => w.nivelDificultad == 1), true);

      final level2 = WordsRepository.getByLevel(2);
      expect(level2.every((w) => w.nivelDificultad == 2), true);
    });

    test('getByPalabra finds existing word case-insensitively', () {
      final result = WordsRepository.getByPalabra('Gato');
      expect(result, isNotNull);
      expect(result!.palabra, 'gato');
    });

    test('getByPalabra returns null for unknown word', () {
      expect(WordsRepository.getByPalabra('xenomorfo'), isNull);
    });

    test('getRandomDistractors returns correct count', () {
      final distractors = WordsRepository.getRandomDistractors('gato', 2);
      expect(distractors.length, 2);
    });

    test('getRandomDistractors excludes the given word', () {
      final distractors = WordsRepository.getRandomDistractors('gato', 5);
      expect(distractors.any((w) => w.palabra == 'gato'), false);
    });
  });

  group('WordData', () {
    test('palabraCompleta joins silabas', () {
      const word = WordData(
        palabra: 'gato',
        imagenAsset: 'assets/images/words/gato.png',
        silabas: ['ga', 'to'],
        nivelDificultad: 1,
      );
      expect(word.palabraCompleta, 'gato');
    });

    test('equality based on palabra', () {
      const w1 = WordData(
        palabra: 'gato',
        imagenAsset: 'a.png',
        silabas: ['ga', 'to'],
        nivelDificultad: 1,
      );
      const w2 = WordData(
        palabra: 'gato',
        imagenAsset: 'b.png',
        silabas: ['ga', 'to'],
        nivelDificultad: 2,
      );
      expect(w1, equals(w2));
    });

    test('different palabras are not equal', () {
      const w1 = WordData(
        palabra: 'gato',
        imagenAsset: 'a.png',
        silabas: ['ga', 'to'],
        nivelDificultad: 1,
      );
      const w2 = WordData(
        palabra: 'pato',
        imagenAsset: 'b.png',
        silabas: ['pa', 'to'],
        nivelDificultad: 1,
      );
      expect(w1, isNot(equals(w2)));
    });
  });
}
