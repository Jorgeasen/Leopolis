import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../letters/data/letters_progress_provider.dart';
import '../../rewards/data/rewards_provider.dart';
import '../../settings/data/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childName =
        ref.watch(settingsProvider).valueOrNull?.childName ?? 'Leo';
    final completedLetters =
        ref.watch(lettersProgressProvider).valueOrNull?.length ?? 0;
    final rewards =
        ref.watch(rewardsProvider).valueOrNull ?? RewardsState.initial;

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
                  _Header(childName: childName),
                  const SizedBox(height: 12),
                  _ProgressBanner(
                    totalStars: rewards.totalStars,
                    completedLetters: completedLetters,
                    currentLevel: rewards.currentLevel,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _ModuleGrid(
                      completedLetters: completedLetters,
                      totalStars: rewards.totalStars,
                    ),
                  ),
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
                  constraints: const BoxConstraints(
                    minWidth: 64,
                    minHeight: 64,
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
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.childName});

  final String childName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '¡Hola, $childName! 🦁',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 4),
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
}

// ── Progress banner ───────────────────────────────────────────────────────────

class _ProgressBanner extends StatelessWidget {
  const _ProgressBanner({
    required this.totalStars,
    required this.completedLetters,
    required this.currentLevel,
  });

  final int totalStars;
  final int completedLetters;
  final int currentLevel;

  static const _levelNames = {1: 'Ratón', 2: 'Conejo', 3: 'Gato', 4: 'León'};

  @override
  Widget build(BuildContext context) {
    final levelName = _levelNames[currentLevel] ?? 'Leo';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BannerStat(
              value: '$totalStars',
              label: 'estrellas',
              emoji: '⭐',
            ),
            _BannerDivider(),
            _BannerStat(
              value: '$completedLetters/27',
              label: 'letras',
              emoji: '🔤',
            ),
            _BannerDivider(),
            _BannerStat(
              value: levelName,
              label: 'nivel $currentLevel',
              emoji: '🏆',
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  const _BannerStat({
    required this.value,
    required this.label,
    required this.emoji,
  });

  final String value;
  final String label;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
            fontFamily: 'Fredoka',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textDark.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _BannerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 48,
        color: AppTheme.primary.withValues(alpha: 0.25),
      );
}

// ── Module grid ───────────────────────────────────────────────────────────────

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({
    required this.completedLetters,
    required this.totalStars,
  });

  final int completedLetters;
  final int totalStars;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 16) / 2;
            final cardHeight = cardWidth.clamp(140.0, 200.0);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: cardWidth / cardHeight,
              children: [
                _ModuleCardWidget(
                  title: 'Las Letras',
                  emoji: '🔤',
                  color: AppTheme.lettersColor,
                  route: AppConstants.routeLetters,
                  progressFraction:
                      completedLetters > 0 ? completedLetters / 27.0 : null,
                  progressLabel:
                      completedLetters > 0 ? '$completedLetters/27' : null,
                  isComplete: completedLetters >= 27,
                  isNew: completedLetters == 0,
                ),
                const _ModuleCardWidget(
                  title: 'Las Palabras',
                  emoji: '📝',
                  color: AppTheme.wordsColor,
                  route: AppConstants.routeWords,
                ),
                const _ModuleCardWidget(
                  title: 'Juegos',
                  emoji: '🎮',
                  color: AppTheme.gamesColor,
                  route: AppConstants.routeGames,
                ),
                _ModuleCardWidget(
                  title: 'Mis Premios',
                  emoji: '⭐',
                  color: AppTheme.rewardsColor,
                  route: AppConstants.routeRewards,
                  progressLabel: totalStars > 0 ? '$totalStars ⭐' : null,
                  isNew: totalStars == 0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModuleCardWidget extends StatelessWidget {
  const _ModuleCardWidget({
    required this.title,
    required this.emoji,
    required this.color,
    required this.route,
    this.progressFraction,
    this.progressLabel,
    this.isNew = false,
    this.isComplete = false,
  });

  final String title;
  final String emoji;
  final Color color;
  final String route;
  final double? progressFraction;
  final String? progressLabel;
  final bool isNew;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return _TappableCard(
      color: color,
      onTap: () => context.go(route),
      child: Stack(
        children: [
          // Contenido principal
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (progressLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    progressLabel!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Barra de progreso en la parte inferior
          if (progressFraction != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: LinearProgressIndicator(
                  value: progressFraction,
                  minHeight: 5,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          // Chip de estado en esquina superior izquierda
          if (isNew || isComplete)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isComplete ? '✅' : '🆕',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── TappableCard (animación de escala en tap) ─────────────────────────────────

class _TappableCard extends StatefulWidget {
  const _TappableCard({
    required this.color,
    required this.onTap,
    required this.child,
  });

  final Color color;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<_TappableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Card(
          color: widget.color,
          child: widget.child,
        ),
      ),
    );
  }
}
