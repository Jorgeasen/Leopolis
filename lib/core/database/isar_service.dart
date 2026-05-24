import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/words/data/word_progress_data.dart';
import 'collections/letter_progress.dart';
import 'collections/rewards_data.dart';
import 'collections/session_data.dart';

class IsarService {
  IsarService._();

  static final IsarService instance = IsarService._();

  Isar? _db;

  Isar get db {
    assert(_db != null, 'IsarService not initialized — call open() first');
    return _db!;
  }

  Future<void> open() async {
    if (_db != null && _db!.isOpen) return;
    final dir = await getApplicationDocumentsDirectory();
    _db = await Isar.open(
      [
        LetterProgressSchema,
        RewardsDataSchema,
        SessionDataSchema,
        WordProgressDataSchema
      ],
      directory: dir.path,
      inspector: false,
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
