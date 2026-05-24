import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../data/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _nameController;
  bool _nameInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('¡Ups! 🦁 Inténtalo otra vez')),
      ),
      data: (settings) {
        if (!_nameInitialized) {
          _nameController.text = settings.childName;
          _nameInitialized = true;
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            title: const Text(
              'Ajustes ⚙️',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.go(AppConstants.routeHome),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 8),
              _Section(
                emoji: '👦',
                label: 'Nombre del niño',
                child: SizedBox(
                  height: 64,
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppTheme.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (value) => ref
                        .read(settingsProvider.notifier)
                        .updateChildName(value),
                    onTapOutside: (_) => ref
                        .read(settingsProvider.notifier)
                        .updateChildName(_nameController.text),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _Section(
                emoji: '🔊',
                label: 'Volumen de voz',
                child: Slider(
                  value: settings.ttsVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: AppTheme.primary,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).updateTtsVolume(v),
                ),
              ),
              const SizedBox(height: 24),
              _Section(
                emoji: '🐢',
                label: 'Velocidad de voz',
                child: Row(
                  children: [
                    _SpeedChip(
                      label: 'Lento',
                      selected: settings.ttsRate < 0.38,
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .updateTtsRate(0.3),
                    ),
                    const SizedBox(width: 12),
                    _SpeedChip(
                      label: 'Normal',
                      selected:
                          settings.ttsRate >= 0.38 && settings.ttsRate <= 0.52,
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .updateTtsRate(0.45),
                    ),
                    const SizedBox(width: 12),
                    _SpeedChip(
                      label: 'Rápido',
                      selected: settings.ttsRate > 0.52,
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .updateTtsRate(0.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Section(
                emoji: '🔔',
                label: 'Sonidos de feedback',
                child: SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        settings.soundEnabled ? 'Activados' : 'Desactivados',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Transform.scale(
                        scale: 1.4,
                        child: Switch(
                          value: settings.soundEnabled,
                          activeThumbColor: AppTheme.secondary,
                          onChanged: (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSoundEnabled(v),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => context.go('/parent-login'),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.rewardsColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.rewardsColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🔒 Zona de padres',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.emoji,
    required this.label,
    required this.child,
  });

  final String emoji;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$emoji $label',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primary,
              width: selected ? 0 : 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : AppTheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
