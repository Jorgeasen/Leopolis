import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/rewards/data/rewards_provider.dart';
import 'package:leopolis/features/rewards/presentation/rewards_screen.dart';

class _FakeRewardsNotifier extends RewardsNotifier {
  @override
  Future<RewardsState> build() async => RewardsState.initial;
}

Widget _buildScreen() {
  return ProviderScope(
    overrides: [
      rewardsProvider.overrideWith(_FakeRewardsNotifier.new),
    ],
    child: const MaterialApp(home: RewardsScreen()),
  );
}

void main() {
  group('RewardsScreen', () {
    testWidgets('muestra encabezado y botón volver', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildScreen());
      await tester.pump();

      expect(find.text('¡Mis Premios! ⭐'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('muestra sección mis logros con cero estrellas',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Mis logros'), findsOneWidget);
      expect(find.text('estrellas'), findsOneWidget);
    });

    testWidgets('muestra nivel 1 en la barra de progreso', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Nivel 1 — Ratón'), findsOneWidget);
    });
  });
}
