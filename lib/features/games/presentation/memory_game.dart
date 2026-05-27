import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../rewards/data/rewards_provider.dart';
import '../../words/data/words_repository.dart';

enum _CardType { image, word }

class _MemoryCard {
  _MemoryCard({
    required this.id,
    required this.wordIndex,
    required this.type,
    required this.word,
    required this.emoji,
  });

  final int id;
  final int wordIndex;
  final _CardType type;
  final String word;
  final String emoji;
  bool isFaceUp = false;
  bool isMatched = false;
}

class MemoryGame extends ConsumerStatefulWidget {
  const MemoryGame({super.key});

  @override
  ConsumerState<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends ConsumerState<MemoryGame> {
  static const int _pairCount = 6;

  final _rng = Random();
  final _tts = FlutterTts();
  final _stopwatch = Stopwatch();

  List<_MemoryCard> _cards = [];
  int? _firstFlippedId;
  bool _comparing = false;
  int _errors = 0;
  int _matchedCount = 0;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _configureTts();
    _cards = _createCards();
    _stopwatch.start();
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
  }

  List<_MemoryCard> _createCards() {
    final words = WordsRepository.getAll().toList()..shuffle(_rng);
    final selected = words.take(_pairCount).toList();
    final cards = <_MemoryCard>[];
    for (int i = 0; i < selected.length; i++) {
      final word = selected[i];
      final emoji = word.emoji.isNotEmpty ? word.emoji : '📝';
      cards.add(_MemoryCard(
        id: i * 2,
        wordIndex: i,
        type: _CardType.image,
        word: word.palabra,
        emoji: emoji,
      ));
      cards.add(_MemoryCard(
        id: i * 2 + 1,
        wordIndex: i,
        type: _CardType.word,
        word: word.palabra,
        emoji: emoji,
      ));
    }
    return cards..shuffle(_rng);
  }

  Future<void> _onCardTap(_MemoryCard card) async {
    if (_comparing || card.isFaceUp || card.isMatched) return;

    setState(() => card.isFaceUp = true);

    if (_firstFlippedId == null) {
      _firstFlippedId = card.id;
      return;
    }

    setState(() => _comparing = true);
    final first = _cards.firstWhere((c) => c.id == _firstFlippedId);

    if (first.wordIndex == card.wordIndex && first.type != card.type) {
      // Match!
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        first.isMatched = true;
        card.isMatched = true;
        _matchedCount++;
        _comparing = false;
        _firstFlippedId = null;
      });
      AudioService.instance.playSuccess();
      try {
        await _tts.speak(card.word);
      } catch (_) {}

      if (_matchedCount >= _pairCount) {
        _stopwatch.stop();
        final stars = _errors == 0 ? 3 : (_errors <= 3 ? 2 : 1);
        ref
            .read(rewardsProvider.notifier)
            .addStars(stars * AppConstants.starsPerExercise);
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) setState(() => _showResults = true);
      }
    } else {
      // No match
      _errors++;
      AudioService.instance.playError();
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      setState(() {
        first.isFaceUp = false;
        card.isFaceUp = false;
        _comparing = false;
        _firstFlippedId = null;
      });
    }
  }

  void _playAgain() {
    _stopwatch.reset();
    _stopwatch.start();
    setState(() {
      _errors = 0;
      _matchedCount = 0;
      _showResults = false;
      _firstFlippedId = null;
      _comparing = false;
      _cards = _createCards();
    });
  }

  @override
  void dispose() {
    // ignore: unawaited_futures — flutter_tts Android threading bug
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      final stars = _errors == 0 ? 3 : (_errors <= 3 ? 2 : 1);
      final elapsed = _stopwatch.elapsed;
      final minutes = elapsed.inMinutes;
      final seconds = elapsed.inSeconds % 60;
      return _ResultsScreen(
        stars: stars,
        errors: _errors,
        timeLabel: minutes > 0 ? '${minutes}m ${seconds}s' : '${seconds}s',
        onPlayAgain: _playAgain,
        onExit: () => context.go('/games'),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.gamesColor,
        foregroundColor: Colors.white,
        title: Text(
          '$_matchedCount / $_pairCount pares',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/games'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '¡Encuentra los pares!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardHeight = (constraints.maxHeight - 3 * 8) / 4;
                    final cardWidth = (constraints.maxWidth - 2 * 8) / 3;
                    final ratio = cardWidth / cardHeight;
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: ratio,
                      ),
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return _MemoryCardWidget(
                          card: card,
                          onTap: () => _onCardTap(card),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card widget ───────────────────────────────────────────────────────────────

class _MemoryCardWidget extends StatelessWidget {
  const _MemoryCardWidget({required this.card, required this.onTap});

  final _MemoryCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget face;
    if (card.isMatched) {
      face = _CardFront(
        card: card,
        isMatched: true,
        key: ValueKey('m${card.id}'),
      );
    } else if (card.isFaceUp) {
      face = _CardFront(
        card: card,
        isMatched: false,
        key: ValueKey('f${card.id}'),
      );
    } else {
      face = _CardBack(key: ValueKey('b${card.id}'));
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: face,
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.gamesColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gamesColor.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text('🦁', style: TextStyle(fontSize: 32)),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    super.key,
    required this.card,
    required this.isMatched,
  });

  final _MemoryCard card;
  final bool isMatched;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isMatched ? AppTheme.success.withValues(alpha: 0.12) : Colors.white;
    final borderColor = isMatched
        ? AppTheme.success
        : AppTheme.gamesColor.withValues(alpha: 0.4);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isMatched ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: card.type == _CardType.image
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(card.emoji, style: const TextStyle(fontSize: 36)),
                  if (isMatched)
                    const Icon(Icons.check_circle,
                        color: AppTheme.success, size: 18),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.word.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isMatched ? AppTheme.success : AppTheme.textDark,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isMatched)
                      const Icon(Icons.check_circle,
                          color: AppTheme.success, size: 18),
                  ],
                ),
              ),
            ),
    );
  }
}

// ── Results ───────────────────────────────────────────────────────────────────

class _ResultsScreen extends StatelessWidget {
  const _ResultsScreen({
    required this.stars,
    required this.errors,
    required this.timeLabel,
    required this.onPlayAgain,
    required this.onExit,
  });

  final int stars;
  final int errors;
  final String timeLabel;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final starsStr =
        List.filled(stars, '⭐').join() + List.filled(3 - stars, '☆').join();

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
                '¡Completaste el tablero!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                starsStr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                'Tiempo: $timeLabel  ·  Errores: $errors',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textDark.withValues(alpha: 0.6),
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
                    '¡Otra vez! 🃏',
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
