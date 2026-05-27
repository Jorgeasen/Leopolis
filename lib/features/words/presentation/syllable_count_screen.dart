import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/session_tracker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/celebration_overlay.dart';
import '../../rewards/data/rewards_provider.dart';
import '../data/word_data.dart';
import '../data/words_repository.dart';

// Colors for syllable highlighting (up to 4 syllables)
const _syllableColors = [
  Color(0xFF9C27B0), // purple
  Color(0xFF2196F3), // blue
  Color(0xFFFF5722), // orange-red
  Color(0xFF4CAF50), // green
];

class SyllableCountScreen extends ConsumerStatefulWidget {
  const SyllableCountScreen({super.key});

  @override
  ConsumerState<SyllableCountScreen> createState() =>
      _SyllableCountScreenState();
}

class _SyllableCountScreenState extends ConsumerState<SyllableCountScreen>
    with TickerProviderStateMixin {
  static const int _totalRounds = 10;

  final _rng = Random();
  final _tts = FlutterTts();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  late WordData _currentWord;
  int _score = 0;
  int _round = 0;
  bool _answered = false;
  int? _shakingNumber;
  bool _showResults = false;
  bool _showSyllables = false;
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    _configureTts();
    _loadNewRound();
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
  }

  Future<void> _speak(String text) async {
    if (_speaking) return;
    _speaking = true;
    try {
      await _tts.speak(text);
    } catch (_) {
      // TTS unavailable on this platform/test environment
    } finally {
      if (mounted) _speaking = false;
    }
  }

  void _loadNewRound() {
    final pool = WordsRepository.getAll().toList()..shuffle(_rng);
    final word = pool.first;

    setState(() {
      _currentWord = word;
      _answered = false;
      _shakingNumber = null;
      _showSyllables = false;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _speak(word.palabra);
    });
  }

  Future<void> _onNumberTap(int number) async {
    if (_answered) return;
    final correct = _currentWord.silabas.length;
    if (number == correct) {
      setState(() {
        _answered = true;
        _score++;
        _round++;
        _showSyllables = true;
      });
      SessionTracker.instance.recordStars(1);
      AudioService.instance.playSuccess();
      if (mounted) CelebrationOverlay.show(context);
      await Future.delayed(const Duration(milliseconds: 1600));
      if (!mounted) return;
      if (_round >= _totalRounds) {
        ref
            .read(rewardsProvider.notifier)
            .addStars(_score * AppConstants.starsPerExercise);
        setState(() => _showResults = true);
      } else {
        _loadNewRound();
      }
    } else {
      setState(() => _shakingNumber = number);
      AudioService.instance.playError();
      _speak(_currentWord.palabra);
      await _shakeController.forward(from: 0);
      if (mounted) setState(() => _shakingNumber = null);
    }
  }

  void _playAgain() {
    setState(() {
      _score = 0;
      _round = 0;
      _showResults = false;
    });
    _loadNewRound();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    // ignore: unawaited_futures — flutter_tts Android threading bug
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _ResultsScreen(
        score: _score,
        total: _totalRounds,
        onPlayAgain: _playAgain,
        onExit: () => context.go('/words'),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.wordsColor,
        foregroundColor: Colors.white,
        title: Text(
          '$_score ⭐',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/words'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _RoundProgress(current: _round, total: _totalRounds),
              const SizedBox(height: 16),
              const Text(
                '¿Cuántas sílabas tiene?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 4,
                child: _WordCard(
                  word: _currentWord,
                  showSyllables: _showSyllables,
                  onTap: () => _speak(_currentWord.palabra),
                ),
              ),
              const SizedBox(height: 20),
              _NumberButtonRow(
                shakeController: _shakeController,
                shakeAnimation: _shakeAnimation,
                shakingNumber: _shakingNumber,
                onTap: _onNumberTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _RoundProgress extends StatelessWidget {
  const _RoundProgress({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ronda $current / $total',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: total > 0 ? current / total : 0,
            minHeight: 8,
            backgroundColor: AppTheme.wordsColor.withValues(alpha: 0.15),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.wordsColor),
          ),
        ),
      ],
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.word,
    required this.showSyllables,
    required this.onTap,
  });

  final WordData word;
  final bool showSyllables;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.wordsColor.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (word.emoji.isNotEmpty)
              Text(word.emoji, style: const TextStyle(fontSize: 72))
            else
              const Icon(Icons.image_rounded, size: 72, color: Colors.grey),
            const SizedBox(height: 12),
            if (showSyllables)
              _SyllableBreakdown(syllables: word.silabas)
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.volume_up_rounded,
                      color: AppTheme.wordsColor, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Toca para escuchar',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SyllableBreakdown extends StatelessWidget {
  const _SyllableBreakdown({required this.syllables});

  final List<String> syllables;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      children: [
        for (int i = 0; i < syllables.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _syllableColors[i % _syllableColors.length],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              syllables[i].toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
      ],
    );
  }
}

class _NumberButtonRow extends StatelessWidget {
  const _NumberButtonRow({
    required this.shakeController,
    required this.shakeAnimation,
    required this.shakingNumber,
    required this.onTap,
  });

  final AnimationController shakeController;
  final Animation<double> shakeAnimation;
  final int? shakingNumber;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int n = 1; n <= 4; n++) ...[
          if (n > 1) const SizedBox(width: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: shakeController,
              builder: (context, child) => Transform.translate(
                offset: Offset(
                  shakingNumber == n ? shakeAnimation.value : 0.0,
                  0,
                ),
                child: child,
              ),
              child: _NumberButton(number: n, onTap: () => onTap(n)),
            ),
          ),
        ],
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({required this.number, required this.onTap});

  final int number;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 80),
        decoration: BoxDecoration(
          color: AppTheme.wordsColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.wordsColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultsScreen extends StatelessWidget {
  const _ResultsScreen({
    required this.score,
    required this.total,
    required this.onPlayAgain,
    required this.onExit,
  });

  final int score;
  final int total;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text('🦁', style: TextStyle(fontSize: 80)),
              ),
              const SizedBox(height: 16),
              const Text(
                '¡Lo hiciste muy bien!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$score / $total ⭐',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.wordsColor,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.wordsColor,
                  ),
                  child: const Text(
                    '¡Otra vez! 🔢',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 64,
                child: OutlinedButton(
                  onPressed: onExit,
                  child: const Text(
                    'Salir',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
