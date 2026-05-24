import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/core/database/session_tracker.dart';

void main() {
  group('SessionTracker', () {
    test('es un singleton', () {
      expect(SessionTracker.instance, same(SessionTracker.instance));
    });

    test('recordStars y recordLetter no lanzan excepción sin sesión abierta',
        () {
      expect(() => SessionTracker.instance.recordStars(3), returnsNormally);
      expect(() => SessionTracker.instance.recordLetter('A'), returnsNormally);
    });
  });
}
