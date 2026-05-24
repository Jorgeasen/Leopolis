import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/database/isar_service.dart';
import 'app_settings.dart';

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final settings = await _load();
    AudioService.instance.setSoundEnabled(settings.soundEnabled);
    return settings;
  }

  Future<AppSettings> _load() async {
    final db = IsarService.instance.db;
    return await db.appSettings.where().anyId().findFirst() ?? AppSettings();
  }

  Future<void> _save(AppSettings settings) async {
    final db = IsarService.instance.db;
    await db.writeTxn(() => db.appSettings.put(settings));
    state = AsyncData(settings);
  }

  Future<void> updateChildName(String name) async {
    final current = await _load();
    current.childName = name.trim().isEmpty ? 'Leo' : name.trim();
    await _save(current);
  }

  Future<void> updateTtsVolume(double volume) async {
    final current = await _load();
    current.ttsVolume = volume;
    await _save(current);
  }

  Future<void> updateTtsRate(double rate) async {
    final current = await _load();
    current.ttsRate = rate;
    await _save(current);
  }

  Future<void> updateSoundEnabled(bool enabled) async {
    final current = await _load();
    current.soundEnabled = enabled;
    AudioService.instance.setSoundEnabled(enabled);
    await _save(current);
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
