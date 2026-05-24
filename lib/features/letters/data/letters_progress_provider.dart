import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/database/collections/letter_progress.dart';
import '../../../core/database/isar_service.dart';

class LettersProgressNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final db = IsarService.instance.db;
    final records = await db.letterProgress.where().anyId().findAll();
    return records.where((r) => r.isCompleted).map((r) => r.letter).toSet();
  }

  Future<void> markCompleted(String letter) async {
    final db = IsarService.instance.db;
    final existing = await db.letterProgress.getByLetter(letter);
    final record = existing ?? (LetterProgress()..letter = letter);
    record.isCompleted = true;
    record.completedAt = DateTime.now();
    await db.writeTxn(() => db.letterProgress.put(record));
    final current = state.valueOrNull ?? {};
    state = AsyncData({...current, letter});
  }

  bool isCompleted(String letter) =>
      state.valueOrNull?.contains(letter) ?? false;

  int get completedCount => state.valueOrNull?.length ?? 0;
}

final lettersProgressProvider =
    AsyncNotifierProvider<LettersProgressNotifier, Set<String>>(
  LettersProgressNotifier.new,
);
