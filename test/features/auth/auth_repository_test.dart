import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/auth/data/auth_repository.dart';
import 'package:leopolis/features/auth/presentation/parent_login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  group('AuthRepository', () {
    test('instance es singleton', () {
      final a = AuthRepository.instance;
      final b = AuthRepository.instance;
      expect(identical(a, b), true);
    });
  });

  group('ParentLoginScreen', () {
    testWidgets('renderiza correctamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentLoginScreen()),
      );
      await tester.pump();

      expect(find.text('Acceso para padres'), findsWidgets);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });
  });
}
