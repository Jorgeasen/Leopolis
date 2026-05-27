import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../data/letters_progress_provider.dart';

class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(lettersProgressProvider);
    final completed = progressAsync.valueOrNull ?? const <String>{};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.lettersColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Las Letras 🔤',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppConstants.routeHome),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${completed.length} / ${AppConstants.spanishAlphabet.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '¡Toca una letra!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 96,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: AppConstants.spanishAlphabet.length,
                itemBuilder: (context, index) {
                  final letter = AppConstants.spanishAlphabet[index];
                  final isDone = completed.contains(letter);
                  return GestureDetector(
                    onTap: () => context.push('/letters/$letter'),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppTheme.secondary.withValues(alpha: 0.15)
                                : AppTheme.lettersColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDone
                                  ? AppTheme.secondary
                                  : AppTheme.lettersColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDone
                                    ? AppTheme.secondary
                                    : AppTheme.lettersColor,
                              ),
                            ),
                          ),
                        ),
                        if (isDone)
                          const Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(
                              Icons.check_circle,
                              color: AppTheme.secondary,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
