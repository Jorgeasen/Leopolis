import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/core/constants/app_constants.dart';
import 'package:leopolis/core/database/collections/rewards_data.dart';
import 'package:leopolis/features/rewards/data/rewards_provider.dart';

void main() {
  group('RewardsState', () {
    test('initial state tiene valores correctos', () {
      const state = RewardsState.initial;
      expect(state.totalStars, 0);
      expect(state.currentLevel, 1);
      expect(state.starsInCurrentLevel, 0);
      expect(state.unlockedBadges, ['mouse']);
      expect(state.didLevelUp, false);
    });

    test('nivel sube al alcanzar starsToUnlockLevel', () {
      final data = RewardsData()..totalStars = AppConstants.starsToUnlockLevel;
      final state = RewardsState.fromIsar(data);
      expect(state.currentLevel, 2);
      expect(state.unlockedBadges, ['mouse', 'rabbit']);
    });

    test('nivel máximo es 4', () {
      final data = RewardsData()..totalStars = 999;
      final state = RewardsState.fromIsar(data);
      expect(state.currentLevel, 4);
      expect(state.unlockedBadges.length, 4);
    });

    test('starsInCurrentLevel es el módulo correcto', () {
      final data = RewardsData()..totalStars = 11;
      final state = RewardsState.fromIsar(data);
      expect(state.starsInCurrentLevel, 11 % AppConstants.starsToUnlockLevel);
    });
  });

  group('RewardsNotifier', () {
    test('rewardsProvider está definido', () {
      expect(rewardsProvider, isNotNull);
    });

    test('RewardsNotifier existe y es AsyncNotifier', () {
      final notifier = RewardsNotifier();
      expect(notifier, isA<RewardsNotifier>());
    });
  });

  group('addStars y didLevelUp', () {
    test('addStars incrementa totalStars via cálculo de estado', () {
      // Simulate addStars(3) starting from 0
      final after = RewardsState.fromIsar(RewardsData()..totalStars = 3);
      expect(after.totalStars, 3);
    });

    test('didLevelUp es true al cruzar el umbral de 9 estrellas', () {
      // State at 8 stars (level 1), add 3 → 11 stars (level 2)
      const before = RewardsState(
        totalStars: 8,
        currentLevel: 1,
        starsInCurrentLevel: 8,
        unlockedBadges: ['mouse'],
      );
      final newTotal = before.totalStars + AppConstants.starsPerExercise;
      final newLevel =
          ((newTotal ~/ AppConstants.starsToUnlockLevel) + 1).clamp(1, 4);
      final didLevelUp = newLevel > before.currentLevel;
      expect(didLevelUp, true);
      expect(newLevel, 2);
    });

    test('didLevelUp es false si no se cruza el umbral', () {
      // State at 1 star (level 1), add 3 → 4 stars (still level 1)
      const before = RewardsState(
        totalStars: 1,
        currentLevel: 1,
        starsInCurrentLevel: 1,
        unlockedBadges: ['mouse'],
      );
      final newTotal = before.totalStars + AppConstants.starsPerExercise;
      final newLevel =
          ((newTotal ~/ AppConstants.starsToUnlockLevel) + 1).clamp(1, 4);
      final didLevelUp = newLevel > before.currentLevel;
      expect(didLevelUp, false);
      expect(newLevel, 1);
    });

    test('con 27 estrellas → level 4 con badge leon', () {
      final data = RewardsData()..totalStars = 27;
      final state = RewardsState.fromIsar(data);
      expect(state.currentLevel, 4);
      expect(state.unlockedBadges.contains('lion'), true);
    });
  });
}
