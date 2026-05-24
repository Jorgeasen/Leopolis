import 'package:isar/isar.dart';

part 'word_progress_data.g.dart';

@collection
class WordProgressData {
  Id id = Isar.autoIncrement;
  int wordMatchCompleted = 0;
  int syllableCompleted = 0;
  DateTime? lastPlayed;
}
