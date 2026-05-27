import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'word_category.dart';

// null = todas las categorías
final selectedCategoryProvider = StateProvider<WordCategory?>((ref) => null);
