import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Botón grande y colorido, diseñado para deditos de 6 años 🦁
class LeoButton extends StatelessWidget {
  const LeoButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.width,
    this.height = 72,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppTheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
