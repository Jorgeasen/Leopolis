import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/core/audio/audio_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('AudioService', () {
    test('es un singleton', () {
      expect(AudioService.instance, same(AudioService.instance));
    });

    test('playSuccess no lanza excepción', () {
      expect(() => AudioService.instance.playSuccess(), returnsNormally);
    });

    test('playError no lanza excepción', () {
      expect(() => AudioService.instance.playError(), returnsNormally);
    });
  });
}
