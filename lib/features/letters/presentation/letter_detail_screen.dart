import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/asset_image_with_fallback.dart';
import '../data/letter_data.dart';
import '../data/letters_progress_provider.dart';
import '../data/letters_repository.dart';

class LetterDetailScreen extends ConsumerStatefulWidget {
  const LetterDetailScreen({super.key, required this.letter});

  final String letter;

  @override
  ConsumerState<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends ConsumerState<LetterDetailScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.speak(text);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Vamos a intentarlo otra vez! 🦁')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completed =
        ref.watch(lettersProgressProvider).valueOrNull?.length ?? 0;

    final data = LettersRepository.getByLetter(widget.letter);
    if (data == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => context.go('/letters'));
      return const SizedBox.shrink();
    }

    final prev = LettersRepository.getPrevious(data.letra)!;
    final next = LettersRepository.getNext(data.letra)!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.lettersColor,
        foregroundColor: Colors.white,
        title: Text(
          'La Letra ${data.letra}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/letters'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$completed/27 🔤',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: completed / 27.0,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LetterDisplay(data: data),
              const SizedBox(height: 24),
              _WordExample(data: data),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _ScaleButton(
                      onTap: () => _speak(data.letra),
                      child: _ttsButton(
                        label: 'Escuchar letra',
                        icon: Icons.volume_up_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ScaleButton(
                      onTap: () => _speak(data.palabraEjemplo),
                      child: _ttsButton(
                        label: 'Escuchar palabra',
                        icon: Icons.record_voice_over_rounded,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ScaleButton(
                onTap: () => context.push('/letters/${data.letra}/tracing'),
                child: _tracingButton(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ScaleButton(
                      onTap: () =>
                          context.pushReplacement('/letters/${prev.letra}'),
                      child: _navButton(
                        label: '◀  ${prev.letra}',
                        color: AppTheme.lettersColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ScaleButton(
                      onTap: () =>
                          context.pushReplacement('/letters/${next.letra}'),
                      child: _navButton(
                        label: '${next.letra}  ▶',
                        color: AppTheme.lettersColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ttsButton({required String label, required IconData icon}) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.lettersColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lettersColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tracingButton() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_rounded, color: Colors.white, size: 28),
          SizedBox(width: 8),
          Text(
            'Practicar trazo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton({required String label, required Color color}) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LetterDisplay extends StatelessWidget {
  const _LetterDisplay({required this.data});

  final LetterData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lettersColor.withValues(alpha: 0.15),
            AppTheme.background,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            data.letra,
            style: const TextStyle(
              fontSize: 200,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
              height: 1.0,
            ),
          ),
          Text(
            data.letra.toLowerCase(),
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
              color: AppTheme.lettersColor.withValues(alpha: 0.8),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _WordExample extends StatelessWidget {
  const _WordExample({required this.data});

  final LetterData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: AssetImageWithFallback(
            assetPath: data.imagenAsset,
            fallbackEmoji: data.emoji,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          data.palabraEjemplo,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ScaleButton extends StatefulWidget {
  const _ScaleButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: widget.child,
      ),
    );
  }
}
