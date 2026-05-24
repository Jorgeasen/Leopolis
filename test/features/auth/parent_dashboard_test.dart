import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/auth/presentation/parent_dashboard_screen.dart';

void main() {
  test('ParentDashboardScreen se puede instanciar', () {
    const widget = ParentDashboardScreen();
    expect(widget, isA<ParentDashboardScreen>());
  });
}
