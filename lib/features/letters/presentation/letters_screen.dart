import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '¡Toca una letra!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: AppConstants.spanishAlphabet.length,
                itemBuilder: (context, index) {
                  final letter = AppConstants.spanishAlphabet[index];
                  return GestureDetector(
                    onTap: () => context.push('/letters/$letter'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lettersColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.lettersColor),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lettersColor,
                          ),
                        ),
                      ),
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
