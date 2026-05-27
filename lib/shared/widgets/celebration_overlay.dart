import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class CelebrationOverlay {
  static void show(
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 1600),
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _CelebrationWidget(
        duration: duration,
        onComplete: entry.remove,
      ),
    );
    Overlay.of(context).insert(entry);
  }
}

class _CelebrationWidget extends StatefulWidget {
  const _CelebrationWidget({
    required this.duration,
    required this.onComplete,
  });

  final Duration duration;
  final VoidCallback onComplete;

  @override
  State<_CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<_CelebrationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = Random();

  static const _starCount = 12;
  late final List<_StarData> _stars;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _stars = List.generate(_starCount, (i) {
      final angle = (i / _starCount) * 2 * pi + _rng.nextDouble() * 0.5;
      final dist = 80.0 + _rng.nextDouble() * 120;
      return _StarData(
        angle: angle,
        distance: dist,
        size: 20.0 + _rng.nextDouble() * 18,
        delay: _rng.nextDouble() * 0.3,
      );
    });
    _ctrl.forward().whenComplete(widget.onComplete);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = _ctrl.value;
          return Stack(
            children: [
              // Fondo semitransparente suave
              Positioned.fill(
                child: Opacity(
                  opacity: (t < 0.2
                          ? t / 0.2
                          : t > 0.7
                              ? (1 - t) / 0.3
                              : 1.0) *
                      0.18,
                  child: const ColoredBox(color: Colors.black),
                ),
              ),
              // Texto central
              Center(
                child: Transform.scale(
                  scale: t < 0.3
                      ? Curves.elasticOut.transform(t / 0.3)
                      : t > 0.75
                          ? 1.0 - (t - 0.75) / 0.25
                          : 1.0,
                  child: Opacity(
                    opacity: t < 0.1
                        ? t / 0.1
                        : t > 0.8
                            ? (1 - t) / 0.2
                            : 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.rewardsColor,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.rewardsColor.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Text(
                        '¡Bien! ⭐',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Estrellas volando
              ..._stars.map((star) {
                final progress =
                    ((t - star.delay) / (1 - star.delay)).clamp(0.0, 1.0);
                final eased = Curves.easeOut.transform(progress);
                final dx = cos(star.angle) * star.distance * eased;
                final dy = sin(star.angle) * star.distance * eased;
                final opacity = progress < 0.2
                    ? progress / 0.2
                    : progress > 0.7
                        ? (1 - progress) / 0.3
                        : 1.0;
                return Center(
                  child: Transform.translate(
                    offset: Offset(dx, dy),
                    child: Opacity(
                      opacity: opacity,
                      child: Text(
                        '⭐',
                        style: TextStyle(fontSize: star.size),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _StarData {
  const _StarData({
    required this.angle,
    required this.distance,
    required this.size,
    required this.delay,
  });

  final double angle;
  final double distance;
  final double size;
  final double delay;
}
