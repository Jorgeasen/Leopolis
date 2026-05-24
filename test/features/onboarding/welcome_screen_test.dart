import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leopolis/features/onboarding/presentation/welcome_screen.dart';
import 'package:leopolis/features/settings/data/app_settings.dart';
import 'package:leopolis/features/settings/data/settings_provider.dart';

void main() {
  group('WelcomeScreen', () {
    Widget buildSubject() {
      return ProviderScope(
        overrides: [
          settingsProvider.overrideWith(() => _FakeSettingsNotifier()),
        ],
        child: const MaterialApp(home: WelcomeScreen()),
      );
    }

    testWidgets('muestra paso 1 con saludo y campo de nombre', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.text('¡Hola! Soy Leo 🦁'), findsOneWidget);
      expect(find.text('¿Cuál es tu nombre?'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('paso 2 muestra letras y botón Siguiente tras navegar',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.tap(find.text('¡Empezamos! →'));
      // Pump individual frames to drive the PageView scroll animation (400ms)
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(find.text('Aprende las letras'), findsOneWidget);
      expect(find.text('Siguiente →'), findsOneWidget);
    });

    testWidgets('paso 3 muestra confirmación y botón A jugar', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      // Navigate to step 2
      await tester.tap(find.text('¡Empezamos! →'));
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      // Navigate to step 3
      await tester.tap(find.text('Siguiente →'));
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(find.textContaining('¡Listo,'), findsOneWidget);
      expect(find.text('¡A jugar! 🎮'), findsOneWidget);
    });
  });
}

class _FakeSettingsNotifier extends SettingsNotifier {
  @override
  Future<AppSettings> build() async => AppSettings();

  @override
  Future<void> completeOnboarding(String childName) async {}
}
