import 'package:isar/isar.dart';

part 'rewards_data.g.dart';

@collection
class RewardsData {
  Id id = Isar.autoIncrement;

  int totalStars = 0;
  int currentLevel = 1;
  List<String> unlockedBadges = [];
  DateTime lastUpdated = DateTime.now();
}
