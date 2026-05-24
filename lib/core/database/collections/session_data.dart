import 'package:isar/isar.dart';

part 'session_data.g.dart';

@collection
class SessionData {
  Id id = Isar.autoIncrement;

  late DateTime startTime;
  DateTime? endTime;
  int starsEarned = 0;
  List<String> lettersAttempted = [];
}
