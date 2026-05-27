import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.gamesColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Juegos 🎮',
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
            const SizedBox(height: 16),
            Text(
              '¿A qué jugamos?',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _GameCard(
              emoji: '🃏',
              titulo: 'Memoria',
              subtitulo: 'Empareja cada imagen con su palabra',
              color: AppTheme.gamesColor,
              onTap: () => context.push('/games/memory'),
            ),
            const SizedBox(height: 16),
            _GameCard(
              emoji: '🔤',
              titulo: 'Letras que caen',
              subtitulo: 'Toca la letra correcta antes de que llegue al suelo',
              color: AppTheme.gamesColor.withValues(alpha: 0.85),
              onTap: () => context.push('/games/falling-letters'),
            ),
            const SizedBox(height: 16),
            _GameCard(
              emoji: '🔍',
              titulo: 'La letra perdida',
              subtitulo: 'Encuentra la letra que le falta a la palabra',
              color: AppTheme.gamesColor.withValues(alpha: 0.85),
              onTap: () => context.push('/games/missing-letter'),
            ),
            const SizedBox(height: 16),
            _GameCard(
              emoji: '🔀',
              titulo: 'Ordenar letras',
              subtitulo: 'Arrastra las letras al lugar correcto',
              color: AppTheme.gamesColor.withValues(alpha: 0.7),
              onTap: () => context.push('/games/word-scramble'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
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
