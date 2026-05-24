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
}
