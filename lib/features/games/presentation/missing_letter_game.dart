import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../words/data/words_repository.dart';

class MissingLetterGame extends StatefulWidget {
  const MissingLetterGame({super.key});

  @override
  State<MissingLetterGame> createState() => _MissingLetterGameState();
}

class _MissingLetterGameState extends State<MissingLetterGame>
    with TickerProviderStateMixin {
  static const int _wordsToWin = 10;

  final _rng = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  late final AnimationController _revealController;
  late final Animation<double> _revealAnimation;

  late String _currentWord;
  late String _imagenAsset;
  late int _hiddenIndex;
  late List<String> _options;
  String? _shakingOption;
  bool _answered = false;
  int _correctCount = 0;
  bool _showResults = false;

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
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    );
    _loadNewWord();
  }

  List<String> _eligibleWords() {
    final all = WordsRepository.getAll();
    if (_correctCount < 4) {
      final short = all.where((w) => w.palabra.length <= 3).toList();
      if (short.isNotEmpty) return short.map((w) => w.palabra).toList();
    } else if (_correctCount < 8) {
      final mid = all.where((w) => w.palabra.length == 4).toList();
      if (mid.isNotEmpty) return mid.map((w) => w.palabra).toList();
    }
    return all
        .where((w) => w.palabra.length >= 4)
        .map((w) => w.palabra)
        .toList();
  }

  void _loadNewWord() {
    final words = _eligibleWords()..shuffle(_rng);
    final palabra = words.first;
    final data = WordsRepository.getByPalabra(palabra)!;
    final upper = palabra.toUpperCase();
    final hiddenIdx = _rng.nextInt(upper.length);
    final correctLetter = upper[hiddenIdx];

    final distractors = AppConstants.spanishAlphabet
        .where((l) => l != correctLetter)
        .toList()
      ..shuffle(_rng);

    final options = [correctLetter, ...distractors.take(3)]..shuffle(_rng);

    _revealController.reset();
    setState(() {
      _currentWord = upper;
      _imagenAsset = data.imagenAsset;
      _hiddenIndex = hiddenIdx;
      _options = options;
      _answered = false;
      _shakingOption = null;
    });
  }

  Future<void> _onOptionTap(String letter) async {
    if (_answered) return;
    final correct = _currentWord[_hiddenIndex];
    if (letter == correct) {
      setState(() {
        _answered = true;
        _correctCount++;
      });
      _revealController.forward();
      _playSound('audio/fanfare.mp3');
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      if (_correctCount >= _wordsToWin) {
        setState(() => _showResults = true);
      } else {
        _loadNewWord();
      }
    } else {
      setState(() => _shakingOption = letter);
      _playSound('audio/boing.mp3');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Inténtalo otra vez! 🦁'),
            duration: Duration(milliseconds: 700),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      await _shakeController.forward(from: 0);
      if (mounted) setState(() => _shakingOption = null);
    }
  }

  void _playAgain() {
    setState(() {
      _correctCount = 0;
      _showResults = false;
    });
    _loadNewWord();
  }

  void _playSound(String assetPath) {
    _audioPlayer.play(AssetSource(assetPath)).catchError((_) {});
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _revealController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _ResultsScreen(
        correctCount: _correctCount,
        onPlayAgain: _playAgain,
        onExit: () => context.go('/games'),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.gamesColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/games'),
          tooltip: 'Salir',
        ),
        title: Text(
          '$_correctCount ✓',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _ImageDisplay(imagenAsset: _imagenAsset),
              ),
              const SizedBox(height: 20),
              _WordDisplay(
                word: _currentWord,
                hiddenIndex: _hiddenIndex,
                answered: _answered,
                revealAnimation: _revealAnimation,
              ),
              const SizedBox(height: 28),
              Row(
                children: _options.map((letter) {
                  final isShaking = _shakingOption == letter;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(
                            isShaking ? _shakeAnimation.value : 0.0,
                            0,
                          ),
                          child: child,
                        ),
                        child: _LetterOptionButton(
                          letter: letter,
                          onTap: () => _onOptionTap(letter),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _ImageDisplay extends StatelessWidget {
  const _ImageDisplay({required this.imagenAsset});
  final String imagenAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.gamesColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        imagenAsset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.image_rounded,
          size: 80,
          color: AppTheme.gamesColor,
        ),
      ),
    );
  }
}

class _WordDisplay extends StatelessWidget {
  const _WordDisplay({
    required this.word,
    required this.hiddenIndex,
    required this.answered,
    required this.revealAnimation,
  });
  final String word;
  final int hiddenIndex;
  final bool answered;
  final Animation<double> revealAnimation;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < word.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: i == hiddenIndex
                  ? _HiddenLetterBlock(
                      letter: word[i],
                      answered: answered,
                      revealAnimation: revealAnimation,
                    )
                  : _LetterBlock(letter: word[i]),
            ),
        ],
      ),
    );
  }
}

class _LetterBlock extends StatelessWidget {
  const _LetterBlock({required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.gamesColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gamesColor, width: 1.5),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.gamesColor,
          ),
        ),
      ),
    );
  }
}

class _HiddenLetterBlock extends StatelessWidget {
  const _HiddenLetterBlock({
    required this.letter,
    required this.answered,
    required this.revealAnimation,
  });
  final String letter;
  final bool answered;
  final Animation<double> revealAnimation;

  @override
  Widget build(BuildContext context) {
    if (answered) {
      return ScaleTransition(
        scale: revealAnimation,
        child: Container(
          width: 56,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.secondary, width: 2),
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondary,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: 56,
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.gamesColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gamesColor, width: 3),
      ),
      child: const Center(
        child: Text(
          '_',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.gamesColor,
          ),
        ),
      ),
    );
  }
}

class _LetterOptionButton extends StatelessWidget {
  const _LetterOptionButton({required this.letter, required this.onTap});
  final String letter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppTheme.gamesColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.gamesColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
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
    required this.correctCount,
    required this.onPlayAgain,
    required this.onExit,
  });
  final int correctCount;
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
              const Text(
                '🦁',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 80),
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
                '$correctCount ✓',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gamesColor,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gamesColor,
                  ),
                  child: const Text(
                    '¡Jugar otra vez! 🎮',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 64,
                child: OutlinedButton(
                  onPressed: onExit,
                  child: const Text('Salir', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
