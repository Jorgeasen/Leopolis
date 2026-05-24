import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/core/sync/sync_service.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('SyncService', () {
    test('es un singleton', () {
      final a = SyncService.instance;
      final b = SyncService.instance;
      expect(identical(a, b), isTrue);
    });

    test('startConnectivityListener no lanza excepción', () {
      expect(
        () => SyncService.instance.startConnectivityListener(),
        returnsNormally,
      );
    });
  });
}
