import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/settings/data/app_settings.dart';
import 'package:leopolis/features/settings/data/settings_provider.dart';

void main() {
  test('AppSettings has correct defaults', () {
    final s = AppSettings();
    expect(s.childName, 'Leo');
    expect(s.ttsVolume, 0.8);
    expect(s.ttsRate, 0.4);
    expect(s.soundEnabled, true);
  });

  test('SettingsNotifier provider can be created', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(settingsProvider, isNotNull);
  });
}
