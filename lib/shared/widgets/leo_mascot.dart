import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

enum LeoState { happy, celebrating, encouraging, thinking, sleeping }

class LeoMascot extends StatefulWidget {
  const LeoMascot({
    super.key,
    this.state = LeoState.happy,
    this.message,
    this.size = 120,
  });

  final LeoState state;
  final String? message;
  final double size;

  @override
  State<LeoMascot> createState() => _LeoMascotState();
}

class _LeoMascotState extends State<LeoMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _animation = _buildAnimation();
    if (widget.state != LeoState.sleeping) {
      _controller.repeat(reverse: true);
    }
  }

  Duration get _duration => switch (widget.state) {
        LeoState.celebrating => const Duration(milliseconds: 600),
        LeoState.encouraging => const Duration(milliseconds: 1400),
        LeoState.thinking => const Duration(milliseconds: 2000),
        LeoState.happy => const Duration(milliseconds: 2500),
        LeoState.sleeping => const Duration(milliseconds: 3000),
      };

  Animation<double> _buildAnimation() => switch (widget.state) {
        LeoState.celebrating => Tween<double>(begin: 1.0, end: 1.3).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
        LeoState.happy => Tween<double>(begin: 1.0, end: 1.06).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
        LeoState.encouraging => Tween<double>(begin: 0.65, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
        LeoState.thinking => Tween<double>(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
        LeoState.sleeping => const AlwaysStoppedAnimation(1.0),
      };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emoji = Text('🦁', style: TextStyle(fontSize: widget.size));

    final animated = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final v = _animation.value;
        return switch (widget.state) {
          LeoState.celebrating ||
          LeoState.happy =>
            Transform.scale(scale: v, child: child),
          LeoState.encouraging ||
          LeoState.thinking =>
            Opacity(opacity: v, child: child),
          LeoState.sleeping => child!,
        };
      },
      child: emoji,
    );

    if (widget.message == null) return animated;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        animated,
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 220),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.message!,
            style: TextStyle(
              fontSize: (widget.size * 0.23).clamp(14.0, 22.0),
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
