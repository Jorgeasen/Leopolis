import 'package:flutter_riverpod/flutter_riverpod.dart';

// Racha de letras trazadas correctamente en la sesión actual.
// Se incrementa en LetterTracingScreen y no se persiste en Isar.
final letterStreakProvider = StateProvider<int>((ref) => 0);
