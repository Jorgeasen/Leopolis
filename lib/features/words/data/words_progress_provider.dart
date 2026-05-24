import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/database/isar_service.dart';
import 'word_progress_data.dart';

class WordsProgressNotifier extends AsyncNotifier<WordProgressData> {
  @override
  Future<WordProgressData> build() async {
    final db = IsarService.instance.db;
    return await db.wordProgressDatas.where().anyId().findFirst() ??
        WordProgressData();
  }

  Future<void> addWordMatchScore() => _increment((d) => d.wordMatchCompleted++);

  Future<void> addSyllableScore() => _increment((d) => d.syllableCompleted++);

  Future<void> _increment(void Function(WordProgressData) fn) async {
    final db = IsarService.instance.db;
    final data = await db.wordProgressDatas.where().anyId().findFirst() ??
        WordProgressData();
    fn(data);
    data.lastPlayed = DateTime.now();
    await db.writeTxn(() => db.wordProgressDatas.put(data));
    state = AsyncData(data);
  }
}

final wordsProgressProvider =
    AsyncNotifierProvider<WordsProgressNotifier, WordProgressData>(
  WordsProgressNotifier.new,
);
