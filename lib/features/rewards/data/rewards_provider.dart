import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/collections/rewards_data.dart';
import '../../../core/database/isar_service.dart';

const _kBadges = ['mouse', 'rabbit', 'cat', 'lion'];

int _calcLevel(int stars) =>
    ((stars ~/ AppConstants.starsToUnlockLevel) + 1).clamp(1, 4);

List<String> _badgesForLevel(int level) => _kBadges.sublist(0, level);

class RewardsState {
  const RewardsState({
    required this.totalStars,
    required this.currentLevel,
    required this.starsInCurrentLevel,
    required this.unlockedBadges,
    this.didLevelUp = false,
  });

  final int totalStars;
  final int currentLevel;
  final int starsInCurrentLevel;
  final List<String> unlockedBadges;
  final bool didLevelUp;

  static const initial = RewardsState(
    totalStars: 0,
    currentLevel: 1,
    starsInCurrentLevel: 0,
    unlockedBadges: ['mouse'],
  );

  factory RewardsState.fromIsar(RewardsData data) {
    final level = _calcLevel(data.totalStars);
    return RewardsState(
      totalStars: data.totalStars,
      currentLevel: level,
      starsInCurrentLevel: data.totalStars % AppConstants.starsToUnlockLevel,
      unlockedBadges: _badgesForLevel(level),
    );
  }
}

class RewardsNotifier extends AsyncNotifier<RewardsState> {
  @override
  Future<RewardsState> build() async {
    final db = IsarService.instance.db;
    final data = await db.rewardsDatas.where().findFirst();
    if (data == null) return RewardsState.initial;
    return RewardsState.fromIsar(data);
  }

  Future<void> addStars(int count) async {
    final current = state.valueOrNull ?? RewardsState.initial;
    final newTotal = current.totalStars + count;
    final newLevel = _calcLevel(newTotal);
    final didLevelUp = newLevel > current.currentLevel;

    final db = IsarService.instance.db;
    final existing = await db.rewardsDatas.where().findFirst();
    final data = existing ?? RewardsData();
    data.totalStars = newTotal;
    data.currentLevel = newLevel;
    data.unlockedBadges = _badgesForLevel(newLevel);
    data.lastUpdated = DateTime.now();
    await db.writeTxn(() => db.rewardsDatas.put(data));

    state = AsyncData(RewardsState(
      totalStars: newTotal,
      currentLevel: newLevel,
      starsInCurrentLevel: newTotal % AppConstants.starsToUnlockLevel,
      unlockedBadges: _badgesForLevel(newLevel),
      didLevelUp: didLevelUp,
    ));
  }
}

final rewardsProvider = AsyncNotifierProvider<RewardsNotifier, RewardsState>(
  RewardsNotifier.new,
);
