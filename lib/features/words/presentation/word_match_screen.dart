import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/session_tracker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/asset_image_with_fallback.dart';
import '../data/word_data.dart';
import '../data/words_repository.dart';

class WordMatchScreen extends StatefulWidget {
  const WordMatchScreen({super.key});

  @override
  State<WordMatchScreen> createState() => _WordMatchScreenState();
}

class _WordMatchScreenState extends State<WordMatchScreen>
    with SingleTickerProviderStateMixin {
  late WordData _currentWord;
  late List<WordData> _options;
  int _score = 0;
  bool _blocked = false;
  String? _shakingWord;
  bool _celebrating = false;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);
    _loadNewWord();
  }

  void _loadNewWord() {
    final all = WordsRepository.getAll().toList()..shuffle(Random());
    final correct = all.first;
    final distractors =
        WordsRepository.getRandomDistractors(correct.palabra, 2);
    final options = [correct, ...distractors]..shuffle(Random());
    setState(() {
      _currentWord = correct;
      _options = options;
      _blocked = false;
      _shakingWord = null;
      _celebrating = false;
    });
  }

  Future<void> _onOptionTap(WordData option) async {
    if (_blocked) return;
    if (option.palabra == _currentWord.palabra) {
      setState(() {
        _blocked = true;
        _celebrating = true;
        _score++;
        SessionTracker.instance.recordStars(1);
      });
      _playSound('audio/fanfare.mp3');
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) _loadNewWord();
    } else {
      setState(() => _shakingWord = option.palabra);
      _playSound('audio/boing.mp3');
      await _shakeController.forward(from: 0);
      if (mounted) setState(() => _shakingWord = null);
    }
  }

  void _playSound(String assetPath) {
    _audioPlayer.play(AssetSource(assetPath)).catchError((_) {});
  }

  @override
  void dispose() {
    _shakeController.dispose();
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
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _ImageDisplay(word: _currentWord),
                    if (_celebrating)
                      AnimatedScale(
                        scale: _celebrating ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: AnimatedOpacity(
                          opacity: _celebrating ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.rewardsColor.withValues(
                                alpha: 0.92,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '¡Muy bien! ⭐',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _options.map((option) {
                    final isShaking = _shakingWord == option.palabra;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: AnimatedBuilder(
                          animation: _shakeController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                isShaking ? _shakeAnimation.value : 0.0,
                                0,
                              ),
                              child: child,
                            );
                          },
                          child: _OptionButton(
                            word: option,
                            onTap: () => _onOptionTap(option),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageDisplay extends StatelessWidget {
  const _ImageDisplay({required this.word});

  final WordData word;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.wordsColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: AssetImageWithFallback(
        assetPath: word.imagenAsset,
        fallbackEmoji: word.emoji,
        emojiFontSize: 120,
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({required this.word, required this.onTap});

  final WordData word;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
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
            word.palabra,
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
