import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/core/database/collections/letter_progress.dart';
import 'package:leopolis/core/database/collections/rewards_data.dart';
import 'package:leopolis/core/database/collections/session_data.dart';

void main() {
  group('Colecciones Isar', () {
    test('LetterProgress se puede crear con valores por defecto', () {
      final lp = LetterProgress()..letter = 'A';
      expect(lp.letter, 'A');
      expect(lp.isCompleted, false);
      expect(lp.tracingAttempts, 0);
      expect(lp.completedAt, isNull);
    });

    test('RewardsData se puede crear con valores por defecto', () {
      final rd = RewardsData();
      expect(rd.totalStars, 0);
      expect(rd.currentLevel, 1);
      expect(rd.unlockedBadges, isEmpty);
    });

    test('SessionData se puede crear con valores por defecto', () {
      final sd = SessionData()..startTime = DateTime.now();
      expect(sd.starsEarned, 0);
      expect(sd.lettersAttempted, isEmpty);
      expect(sd.endTime, isNull);
    });
  });
}
