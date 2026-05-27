import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/core/audio/audio_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Silencia todos los métodos del canal flutter_tts en el entorno de test
    // donde no hay implementación nativa disponible.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => null,
    );
  });

  group('AudioService', () {
    test('es un singleton', () {
      expect(AudioService.instance, same(AudioService.instance));
    });

    test('playSuccess no lanza excepción', () async {
      await expectLater(AudioService.instance.playSuccess(), completes);
    });

    test('playError no lanza excepción', () async {
      await expectLater(AudioService.instance.playError(), completes);
    });
  });
}
