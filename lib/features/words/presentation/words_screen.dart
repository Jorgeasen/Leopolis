import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../data/selected_category_provider.dart';
import '../data/word_category.dart';
import '../data/words_progress_provider.dart';

class WordsScreen extends ConsumerWidget {
  const WordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(wordsProgressProvider);
    final wordMatchCount = progressAsync.valueOrNull?.wordMatchCompleted ?? 0;
    final syllableCount = progressAsync.valueOrNull?.syllableCompleted ?? 0;
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.wordsColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Las Palabras 📝',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppConstants.routeHome),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              '¿Qué quieres practicar?',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _CategorySelector(
              selected: selectedCategory,
              onSelected: (cat) =>
                  ref.read(selectedCategoryProvider.notifier).state = cat,
            ),
            const SizedBox(height: 24),
            _ExerciseCard(
              emoji: '🖼️',
              titulo: 'Adivina la Palabra',
              subtitulo: wordMatchCount > 0
                  ? '$wordMatchCount aciertos ⭐'
                  : 'Ve la imagen y elige la palabra correcta',
              color: AppTheme.wordsColor,
              onTap: () => context.push('/words/match'),
            ),
            const SizedBox(height: 16),
            _ExerciseCard(
              emoji: '🔤',
              titulo: 'Completa la Sílaba',
              subtitulo: syllableCount > 0
                  ? '$syllableCount aciertos ⭐'
                  : 'Encuentra la sílaba que falta en la palabra',
              color: AppTheme.wordsColor.withValues(alpha: 0.8),
              onTap: () => context.push('/words/syllable'),
            ),
            const SizedBox(height: 16),
            _ExerciseCard(
              emoji: '🔊',
              titulo: 'Dictado',
              subtitulo: 'Escucha la sílaba y encuéntrala',
              color: AppTheme.wordsColor.withValues(alpha: 0.6),
              onTap: () => context.push('/words/syllable-dictation'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.selected, required this.onSelected});

  final WordCategory? selected;
  final void Function(WordCategory?) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(
            label: 'Todas',
            emoji: '✨',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          ...WordCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _CategoryChip(
                label: cat.nombre,
                emoji: cat.emoji,
                isSelected: selected == cat,
                onTap: () => onSelected(selected == cat ? null : cat),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.wordsColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.wordsColor,
            width: isSelected ? 0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.wordsColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.wordsColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  final String emoji;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}
