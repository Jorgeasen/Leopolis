import 'package:isar/isar.dart';

part 'letter_progress.g.dart';

@collection
class LetterProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String letter;

  bool isCompleted = false;
  DateTime? completedAt;
  int tracingAttempts = 0;
}
