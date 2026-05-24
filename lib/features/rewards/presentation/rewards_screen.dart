import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../data/rewards_provider.dart';

const _kLevelNames = ['Ratón', 'Conejo', 'Gato', 'León'];
const _kLevelEmojis = ['🐭', '🐰', '🐱', '🦁'];

const _kBadgeData = [
  {'key': 'mouse', 'emoji': '🐭', 'name': 'Ratón'},
  {'key': 'rabbit', 'emoji': '🐰', 'name': 'Conejo'},
  {'key': 'cat', 'emoji': '🐱', 'name': 'Gato'},
  {'key': 'lion', 'emoji': '🦁', 'name': 'León'},
];

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _celebrationCtrl;
  bool _hasPlayedCelebration = false;

  @override
  void initState() {
    super.initState();
    _celebrationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(rewardsProvider).valueOrNull;
      if (state?.didLevelUp == true) {
        _hasPlayedCelebration = true;
        _celebrationCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _celebrationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<RewardsState>>(rewardsProvider, (_, next) {
      next.whenData((state) {
        if (state.didLevelUp && !_hasPlayedCelebration) {
          _hasPlayedCelebration = true;
          _celebrationCtrl.forward(from: 0);
        }
      });
    });

    final rewardsAsync = ref.watch(rewardsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.rewardsColor,
        foregroundColor: AppTheme.textDark,
        title: const Text(
          '¡Mis Premios! ⭐',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppConstants.routeHome),
        ),
      ),
      body: Stack(
        children: [
          rewardsAsync.when(
            loading: () => const _SkeletonBody(),
            error: (_, __) => const _ErrorBody(),
            data: (rewards) => _RewardsBody(rewards: rewards),
          ),
          ValueListenableBuilder<double>(
            valueListenable: _celebrationCtrl,
            builder: (_, value, __) {
              if (value <= 0.0 || value >= 1.0) return const SizedBox.shrink();
              return _CelebrationOverlay(progress: value);
            },
          ),
        ],
      ),
    );
  }
}

class _RewardsBody extends StatelessWidget {
  const _RewardsBody({required this.rewards});

  final RewardsState rewards;

  @override
  Widget build(BuildContext context) {
    final levelIndex = (rewards.currentLevel - 1).clamp(0, 3);
    final levelName = _kLevelNames[levelIndex];
    final levelEmoji = _kLevelEmojis[levelIndex];
    final progress =
        rewards.starsInCurrentLevel / AppConstants.starsToUnlockLevel;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StarCounter(totalStars: rewards.totalStars),
            const SizedBox(height: 24),
            _LevelProgress(
              levelName: levelName,
              levelEmoji: levelEmoji,
              levelNumber: rewards.currentLevel,
              starsInLevel: rewards.starsInCurrentLevel,
              progress: progress,
              isMaxLevel: rewards.currentLevel >= 4,
            ),
            const SizedBox(height: 32),
            _BadgesGrid(unlockedBadges: rewards.unlockedBadges),
          ],
        ),
      ),
    );
  }
}

class _StarCounter extends StatelessWidget {
  const _StarCounter({required this.totalStars});

  final int totalStars;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: totalStars),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (_, value, __) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppTheme.rewardsColor.withValues(alpha: 0.3),
                AppTheme.background,
              ],
              radius: 0.8,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 64)),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  height: 1.0,
                ),
              ),
              const Text(
                'estrellas',
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LevelProgress extends StatelessWidget {
  const _LevelProgress({
    required this.levelName,
    required this.levelEmoji,
    required this.levelNumber,
    required this.starsInLevel,
    required this.progress,
    required this.isMaxLevel,
  });

  final String levelName;
  final String levelEmoji;
  final int levelNumber;
  final int starsInLevel;
  final double progress;
  final bool isMaxLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.rewardsColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(levelEmoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nivel $levelNumber — $levelName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  if (isMaxLevel)
                    const Text(
                      '¡Nivel máximo! 🏆',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondary,
                      ),
                    )
                  else
                    Text(
                      '★ $starsInLevel / ${AppConstants.starsToUnlockLevel}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textDark.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (!isMaxLevel) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (_, value, __) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 20,
                    backgroundColor:
                        AppTheme.rewardsColor.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.rewardsColor,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  const _BadgesGrid({required this.unlockedBadges});

  final List<String> unlockedBadges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis logros',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.05,
          children: _kBadgeData.map((b) {
            final isUnlocked = unlockedBadges.contains(b['key']);
            return _BadgeCard(
              emoji: b['emoji']!,
              name: b['name']!,
              isUnlocked: isUnlocked,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BadgeCard extends StatefulWidget {
  const _BadgeCard({
    required this.emoji,
    required this.name,
    required this.isUnlocked,
  });

  final String emoji;
  final String name;
  final bool isUnlocked;

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTap(BuildContext context) {
    if (widget.isUnlocked) {
      _scaleCtrl.forward(from: 0);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '¡Sigue así para ganarlo! 🦁',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isUnlocked ? Colors.white : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isUnlocked
                  ? AppTheme.rewardsColor
                  : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: widget.isUnlocked
                ? [
                    BoxShadow(
                      color: AppTheme.rewardsColor.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isUnlocked ? widget.emoji : '🔒',
                style: TextStyle(
                  fontSize: 48,
                  color: widget.isUnlocked ? null : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.isUnlocked
                      ? AppTheme.textDark
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CelebrationOverlay extends StatelessWidget {
  const _CelebrationOverlay({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _StarRainPainter(progress: progress),
        ),
      ),
    );
  }
}

class _StarParticle {
  const _StarParticle({
    required this.x,
    required this.delay,
    required this.size,
  });

  final double x;
  final double delay;
  final double size;
}

class _StarRainPainter extends CustomPainter {
  _StarRainPainter({required this.progress});

  final double progress;

  static final List<_StarParticle> _particles = List.generate(28, (i) {
    final rng = Random(i * 41 + 7);
    return _StarParticle(
      x: rng.nextDouble(),
      delay: rng.nextDouble() * 0.5,
      size: 16 + rng.nextDouble() * 24,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (final p in _particles) {
      final t = ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      if (opacity <= 0) continue;
      tp.text = TextSpan(
        text: '⭐',
        style: TextStyle(
          fontSize: p.size,
          color: Colors.white.withValues(alpha: opacity),
        ),
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(size.width * p.x, size.height * t - tp.height),
      );
    }
  }

  @override
  bool shouldRepaint(_StarRainPainter old) => old.progress != progress;
}

class _SkeletonBody extends StatelessWidget {
  const _SkeletonBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.rewardsColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🦁', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            '¡Vamos a intentarlo otra vez!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
