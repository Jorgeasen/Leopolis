import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('spanishAlphabet tiene 27 elementos', () {
      expect(AppConstants.spanishAlphabet.length, 27);
    });

    test('spanishAlphabet contiene Ñ', () {
      expect(AppConstants.spanishAlphabet.contains('Ñ'), true);
    });

    test('starsPerExercise es 3', () {
      expect(AppConstants.starsPerExercise, 3);
    });

    test('starsToUnlockLevel es 9', () {
      expect(AppConstants.starsToUnlockLevel, 9);
    });
  });
}
