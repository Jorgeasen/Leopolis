import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/words/data/word_progress_data.dart';

void main() {
  group('WordProgressData', () {
    test('valores iniciales son cero', () {
      final data = WordProgressData();
      expect(data.wordMatchCompleted, 0);
      expect(data.syllableCompleted, 0);
      expect(data.lastPlayed, isNull);
    });

    test('se puede incrementar wordMatchCompleted', () {
      final data = WordProgressData();
      data.wordMatchCompleted++;
      expect(data.wordMatchCompleted, 1);
    });

    test('se puede incrementar syllableCompleted', () {
      final data = WordProgressData();
      data.syllableCompleted += 3;
      expect(data.syllableCompleted, 3);
    });
  });
}
