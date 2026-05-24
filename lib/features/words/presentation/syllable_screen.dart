import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/word_data.dart';
import '../data/words_repository.dart';

class SyllableScreen extends StatefulWidget {
  const SyllableScreen({super.key});

  @override
  State<SyllableScreen> createState() => _SyllableScreenState();
}

class _SyllableScreenState extends State<SyllableScreen>
    with TickerProviderStateMixin {
  late WordData _currentWord;
  late int _hiddenIndex;
  late List<String> _options;
  int _score = 0;
  bool _answered = false;
  String? _shakingOption;
  bool _celebrating = false;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.bounceOut),
    );
    _loadNewWord();
  }

  void _loadNewWord() {
    final rng = Random();
    final eligible = WordsRepository.getAll()
        .where((w) => w.silabas.length >= 2)
        .toList()
      ..shuffle(rng);

    final word = eligible.first;
    final hiddenIdx = rng.nextInt(word.silabas.length);
    final correctSyllable = word.silabas[hiddenIdx];

    final distractors = WordsRepository.getAll()
        .where((w) => w.palabra != word.palabra)
        .expand((w) => w.silabas)
        .where((s) => s != correctSyllable)
        .toSet()
        .toList()
      ..shuffle(rng);

    final options = [correctSyllable, ...distractors.take(2)]..shuffle(rng);

    _slideController.reset();
    setState(() {
      _currentWord = word;
      _hiddenIndex = hiddenIdx;
      _options = options;
      _answered = false;
      _shakingOption = null;
      _celebrating = false;
    });
  }

  Future<void> _onOptionTap(String syllable) async {
    if (_answered) return;
    final correct = _currentWord.silabas[_hiddenIndex];
    if (syllable == correct) {
      setState(() {
        _answered = true;
        _celebrating = true;
        _score++;
      });
      _slideController.forward();
      _playSound('audio/fanfare.mp3');
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) _loadNewWord();
    } else {
      setState(() => _shakingOption = syllable);
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

  void _playSound(String assetPath) {
    _audioPlayer.play(AssetSource(assetPath)).catchError((_) {});
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _slideController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _ImageDisplay(imagenAsset: _currentWord.imagenAsset),
                    if (_celebrating)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.rewardsColor.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '¡Correcto! ⭐',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _WordDisplay(
                word: _currentWord,
                hiddenIndex: _hiddenIndex,
                answered: _answered,
                slideAnimation: _slideAnimation,
              ),
              const SizedBox(height: 28),
              Row(
                children: _options.map((syllable) {
                  final isShaking = _shakingOption == syllable;
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
                        child: _SyllableOptionButton(
                          syllable: syllable,
                          onTap: () => _onOptionTap(syllable),
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

class _ImageDisplay extends StatelessWidget {
  const _ImageDisplay({required this.imagenAsset});

  final String imagenAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.wordsColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        imagenAsset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.image_rounded,
          size: 80,
          color: AppTheme.wordsColor,
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
    required this.slideAnimation,
  });

  final WordData word;
  final int hiddenIndex;
  final bool answered;
  final Animation<Offset> slideAnimation;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < word.silabas.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: i == hiddenIndex
                  ? _HiddenBlock(
                      syllable: word.silabas[i],
                      answered: answered,
                      slideAnimation: slideAnimation,
                    )
                  : _SyllableBlock(syllable: word.silabas[i]),
            ),
        ],
      ),
    );
  }
}

class _SyllableBlock extends StatelessWidget {
  const _SyllableBlock({required this.syllable});

  final String syllable;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      constraints: const BoxConstraints(minWidth: 80),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.wordsColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.wordsColor, width: 1.5),
      ),
      child: Center(
        child: Text(
          syllable.toUpperCase(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.wordsColor,
          ),
        ),
      ),
    );
  }
}

class _HiddenBlock extends StatelessWidget {
  const _HiddenBlock({
    required this.syllable,
    required this.answered,
    required this.slideAnimation,
  });

  final String syllable;
  final bool answered;
  final Animation<Offset> slideAnimation;

  @override
  Widget build(BuildContext context) {
    if (answered) {
      return ClipRect(
        child: SlideTransition(
          position: slideAnimation,
          child: Container(
            height: 64,
            constraints: const BoxConstraints(minWidth: 80),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.secondary, width: 2),
            ),
            child: Center(
              child: Text(
                syllable.toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondary,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      height: 64,
      constraints: const BoxConstraints(minWidth: 80),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.wordsColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.wordsColor, width: 3),
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.wordsColor,
          ),
        ),
      ),
    );
  }
}

class _SyllableOptionButton extends StatelessWidget {
  const _SyllableOptionButton({required this.syllable, required this.onTap});

  final String syllable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        constraints: const BoxConstraints(minWidth: 80),
        decoration: BoxDecoration(
          color: AppTheme.wordsColor,
          borderRadius: BorderRadius.circular(16),
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
            syllable.toUpperCase(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
