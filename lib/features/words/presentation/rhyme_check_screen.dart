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
import '../data/rhyme_data.dart';
import '../data/word_category.dart';
import '../data/words_repository.dart';

class RhymeCheckScreen extends ConsumerStatefulWidget {
  const RhymeCheckScreen({super.key});

  @override
  ConsumerState<RhymeCheckScreen> createState() => _RhymeCheckScreenState();
}

class _RhymeCheckScreenState extends ConsumerState<RhymeCheckScreen>
    with TickerProviderStateMixin {
  static const int _totalRounds = 10;

  final _rng = Random();
  final _tts = FlutterTts();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  late String _word1;
  late String _emoji1;
  late String _word2;
  late String _emoji2;
  bool _isRhymeRound = true;
  int _score = 0;
  int _round = 0;
  bool _answered = false;
  bool _shaking = false;
  bool _showResults = false;
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
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
    try {
      await _tts.speak(text);
    } catch (_) {
      // TTS unavailable on this platform/test environment
    }
  }

  Future<void> _speakPair() async {
    if (_speaking) return;
    _speaking = true;
    try {
      await _speak(_word1);
      await Future.delayed(const Duration(milliseconds: 400));
      await _speak(_word2);
    } finally {
      if (mounted) _speaking = false;
    }
  }

  void _loadNewRound() {
    if (_rng.nextBool()) {
      _loadRhymeRound();
    } else {
      _loadNonRhymeRound();
    }
  }

  void _loadRhymeRound() {
    final pair = kRhymePairs[_rng.nextInt(kRhymePairs.length)];
    setState(() {
      _word1 = pair.word1;
      _emoji1 = pair.emoji1;
      _word2 = pair.word2;
      _emoji2 = pair.emoji2;
      _isRhymeRound = true;
      _answered = false;
      _shaking = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _speakPair();
    });
  }

  void _loadNonRhymeRound() {
    final categories = WordCategory.values.toList()..shuffle(_rng);
    final cat1 = categories[0];
    final cat2 = categories[1];
    final words1 = WordsRepository.getByCategory(cat1).toList()..shuffle(_rng);
    final words2 = WordsRepository.getByCategory(cat2).toList()..shuffle(_rng);

    final w1 = words1.first;
    // Ensure the two words don't accidentally rhyme (last 2 chars differ)
    final w2 = words2.firstWhere(
      (w) =>
          w.palabra.length >= 2 &&
          w1.palabra.length >= 2 &&
          w.palabra.substring(w.palabra.length - 2) !=
              w1.palabra.substring(w1.palabra.length - 2),
      orElse: () => words2.first,
    );

    setState(() {
      _word1 = w1.palabra;
      _emoji1 = w1.emoji.isNotEmpty ? w1.emoji : '📝';
      _word2 = w2.palabra;
      _emoji2 = w2.emoji.isNotEmpty ? w2.emoji : '📝';
      _isRhymeRound = false;
      _answered = false;
      _shaking = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _speakPair();
    });
  }

  Future<void> _onAnswer(bool userSaysRhyme) async {
    if (_answered) return;
    final correct = userSaysRhyme == _isRhymeRound;
    if (correct) {
      setState(() {
        _answered = true;
        _score++;
        _round++;
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
      setState(() => _shaking = true);
      AudioService.instance.playError();
      await _shakeController.forward(from: 0);
      if (mounted) {
        setState(() => _shaking = false);
        _speakPair();
      }
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
                '¿Riman estas palabras?',
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
                child: _WordPairCard(
                  word1: _word1,
                  emoji1: _emoji1,
                  word2: _word2,
                  emoji2: _emoji2,
                  onTap: _speakPair,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(_shaking ? _shakeAnimation.value : 0.0, 0),
                  child: child,
                ),
                child: _AnswerButtons(onAnswer: _onAnswer),
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

class _WordPairCard extends StatelessWidget {
  const _WordPairCard({
    required this.word1,
    required this.emoji1,
    required this.word2,
    required this.emoji2,
    required this.onTap,
  });

  final String word1;
  final String emoji1;
  final String word2;
  final String emoji2;
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
            Row(
              children: [
                Expanded(child: _WordTile(word: word1, emoji: emoji1)),
                Container(
                  width: 2,
                  height: 80,
                  color: AppTheme.wordsColor.withValues(alpha: 0.15),
                ),
                Expanded(child: _WordTile(word: word2, emoji: emoji2)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.volume_up_rounded,
                    color: AppTheme.wordsColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Toca para escuchar',
                  style: TextStyle(
                    fontSize: 13,
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

class _WordTile extends StatelessWidget {
  const _WordTile({required this.word, required this.emoji});

  final String word;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 52)),
        const SizedBox(height: 8),
        Text(
          word.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AnswerButtons extends StatelessWidget {
  const _AnswerButtons({required this.onAnswer});

  final void Function(bool) onAnswer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AnswerButton(
            label: '✓ ¡Sí riman!',
            color: const Color(0xFF4CAF50),
            onTap: () => onAnswer(true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _AnswerButton(
            label: '✗ No riman',
            color: const Color(0xFFFF5722),
            onTap: () => onAnswer(false),
          ),
        ),
      ],
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 80),
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
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
                    '¡Otra vez! 🎵',
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
