import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Header con título y mascota
              _buildHeader(context),
              const SizedBox(height: 32),
              // Grid de módulos
              Expanded(child: _buildModuleGrid(context)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text('¡Hola, Leo! 🦁',
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
          route: AppConstants.routeWords),
      const _ModuleCard(
          title: 'Juegos',
          emoji: '🎮',
          color: AppTheme.gamesColor,
          route: AppConstants.routeGames),
      const _ModuleCard(
        title: 'Mis Premios',
        emoji: '⭐',
        color: AppTheme.rewardsColor,
        route: AppConstants.routeRewards,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: modules.map((m) => _buildModuleCard(context, m)).toList(),
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
            Text(module.emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              module.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard {
  const _ModuleCard(
      {required this.title,
      required this.emoji,
      required this.color,
      required this.route});

  final String title;
  final String emoji;
  final Color color;
  final String route;
}
