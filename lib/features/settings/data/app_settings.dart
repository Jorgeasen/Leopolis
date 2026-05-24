import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement;
  String childName = 'Leo';
  double ttsVolume = 0.8;
  double ttsRate = 0.4;
  bool soundEnabled = true;
  bool hasCompletedOnboarding = false;
}
