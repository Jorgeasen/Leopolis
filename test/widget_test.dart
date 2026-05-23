import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leopolis/app.dart';

void main() {
  testWidgets('HomeScreen muestra los módulos', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LeoPolisApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Las Letras'), findsOneWidget);
    expect(find.text('Las Palabras'), findsOneWidget);
    expect(find.text('Juegos'), findsOneWidget);
    expect(find.text('Mis Premios'), findsOneWidget);
  });
}
