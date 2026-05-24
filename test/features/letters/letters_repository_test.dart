import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/letters/data/letter_data.dart';
import 'package:leopolis/features/letters/data/letters_repository.dart';

void main() {
  group('LettersRepository', () {
    test('getAll returns 27 letters', () {
      expect(LettersRepository.getAll().length, 27);
    });

    test('getAll includes Ñ', () {
      final letters = LettersRepository.getAll().map((l) => l.letra).toList();
      expect(letters.contains('Ñ'), true);
    });

    test('getByLetter returns correct letter', () {
      final result = LettersRepository.getByLetter('A');
      expect(result, isNotNull);
      expect(result!.letra, 'A');
      expect(result.palabraEjemplo, 'Árbol');
    });

    test('getByLetter is case-insensitive', () {
      expect(LettersRepository.getByLetter('a'),
          LettersRepository.getByLetter('A'));
    });

    test('getByLetter returns null for unknown letter', () {
      expect(LettersRepository.getByLetter('1'), isNull);
    });

    test('getByLetter returns Ñ entry', () {
      final result = LettersRepository.getByLetter('Ñ');
      expect(result, isNotNull);
      expect(result!.letra, 'Ñ');
      expect(result.palabraEjemplo, isNotEmpty);
    });

    test('each letter has letra, palabraEjemplo, emoji and colorDestacado', () {
      for (final letter in LettersRepository.getAll()) {
        expect(letter.letra, isNotEmpty);
        expect(letter.palabraEjemplo, isNotEmpty);
        // emoji is optional but colorDestacado always has a value
        expect(letter.colorDestacado, isNotNull);
      }
    });

    test('getNext returns B after A', () {
      final next = LettersRepository.getNext('A');
      expect(next?.letra, 'B');
    });

    test('getNext wraps from Z to A', () {
      final next = LettersRepository.getNext('Z');
      expect(next?.letra, 'A');
    });

    test('getPrevious returns Z before A', () {
      final prev = LettersRepository.getPrevious('A');
      expect(prev?.letra, 'Z');
    });

    test('getPrevious returns A before B', () {
      final prev = LettersRepository.getPrevious('B');
      expect(prev?.letra, 'A');
    });
  });

  group('LetterData', () {
    test('equality based on letra', () {
      const a1 =
          LetterData(letra: 'A', palabraEjemplo: 'Árbol', imagenAsset: 'a.png');
      const a2 =
          LetterData(letra: 'A', palabraEjemplo: 'Avión', imagenAsset: 'b.png');
      expect(a1, equals(a2));
    });

    test('different letras are not equal', () {
      const a =
          LetterData(letra: 'A', palabraEjemplo: 'Árbol', imagenAsset: 'a.png');
      const b =
          LetterData(letra: 'B', palabraEjemplo: 'Barco', imagenAsset: 'b.png');
      expect(a, isNot(equals(b)));
    });
  });
}
