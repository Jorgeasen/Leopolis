import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/letters/data/letters_progress_provider.dart';
import 'package:leopolis/core/database/collections/letter_progress.dart';

void main() {
  group('LettersProgressNotifier', () {
    test('lettersProgressProvider está definido', () {
      expect(lettersProgressProvider, isNotNull);
    });

    test('LetterProgress se crea con valores correctos', () {
      final record = LetterProgress()
        ..letter = 'A'
        ..isCompleted = true
        ..completedAt = DateTime(2024);

      expect(record.letter, 'A');
      expect(record.isCompleted, true);
      expect(record.completedAt, DateTime(2024));
    });

    test('LettersProgressNotifier existe y es AsyncNotifier', () {
      final notifier = LettersProgressNotifier();
      expect(notifier, isA<LettersProgressNotifier>());
    });
  });
}
