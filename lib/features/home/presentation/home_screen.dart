import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/data/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final childName = settingsAsync.valueOrNull?.childName ?? 'Leo';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 24),
                  _buildHeader(context, childName),
                  const SizedBox(height: 32),
                  Expanded(child: _buildModuleGrid(context)),
                  const SizedBox(height: 16),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.settings_rounded,
                    size: 32,
                    color: AppTheme.textDark,
                  ),
                  onPressed: () => context.go(AppConstants.routeSettings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String childName) {
    return Column(
      children: [
        Text('¡Hola, $childName! 🦁',
            style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Text(
          '¿Qué quieres aprender hoy?',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppTheme.textDark.withValues(alpha: 0.7)),
        ),
      ],
    );
  }

  Widget _buildModuleGrid(BuildContext context) {
    final modules = [
      const _ModuleCard(
        title: 'Las Letras',
        emoji: '🔤',
        color: AppTheme.lettersColor,
        route: AppConstants.routeLetters,
      ),
      const _ModuleCard(
        title: 'Las Palabras',
        emoji: '📝',
        color: AppTheme.wordsColor,
        route: AppConstants.routeWords,
      ),
      const _ModuleCard(
        title: 'Juegos',
        emoji: '🎮',
        color: AppTheme.gamesColor,
        route: AppConstants.routeGames,
      ),
      const _ModuleCard(
        title: 'Mis Premios',
        emoji: '⭐',
        color: AppTheme.rewardsColor,
        route: AppConstants.routeRewards,
      ),
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 16) / 2;
            // Cap card height so they always fit on screen (140–200px)
            final cardHeight = cardWidth.clamp(140.0, 200.0);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: cardWidth / cardHeight,
              children:
                  modules.map((m) => _buildModuleCard(context, m)).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, _ModuleCard module) {
    return GestureDetector(
      onTap: () => context.go(module.route),
      child: Card(
        color: module.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(module.emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 8),
            Text(
              module.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard {
  const _ModuleCard({
    required this.title,
    required this.emoji,
    required this.color,
    required this.route,
  });

  final String title;
  final String emoji;
  final Color color;
  final String route;
}
