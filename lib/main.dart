import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.instance.open();

  // Orientación horizontal para tablets (más cómodo para niños)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(
      child: LeoPolisApp(),
    ),
  );
}
