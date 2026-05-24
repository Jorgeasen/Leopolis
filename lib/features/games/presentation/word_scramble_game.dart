import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/session_tracker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/leo_mascot.dart';
import '../../words/data/words_repository.dart';

class WordScrambleGame extends StatefulWidget {
  const WordScrambleGame({super.key});

  @override
  State<WordScrambleGame> createState() => _WordScrambleGameState();
}

class _WordScrambleGameState extends State<WordScrambleGame>
    with SingleTickerProviderStateMixin {
  static const int _wordsToWin = 8;

  final _rng = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  late String _currentWord;
  late String _imagenAsset;
  late List<String?> _slots;
  late List<String?> _available;
  int? _shakingSlot;
  int? _hoverSlot;
  int _completedWords = 0;
  bool _showCelebration = false;
  bool _showResults = false;

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
    _loadNewWord();
  }

  List<String> _eligibleWords() {
    final all = WordsRepository.getAll();
    if (_completedWords < 3) {
      final short = all.where((w) => w.palabra.length == 3).toList();
      if (short.isNotEmpty) return short.map((w) => w.palabra).toList();
    } else if (_completedWords < 6) {
      final mid = all.where((w) => w.palabra.length == 4).toList();
      if (mid.isNotEmpty) return mid.map((w) => w.palabra).toList();
    }
    return all
        .where((w) => w.palabra.length >= 5)
        .map((w) => w.palabra)
        .toList();
  }

  void _loadNewWord() {
    final words = _eligibleWords()..shuffle(_rng);
    final palabra = words.first;
    final data = WordsRepository.getByPalabra(palabra)!;
    final upper = palabra.toUpperCase();
    final shuffled = upper.split('')..shuffle(_rng);

    setState(() {
      _currentWord = upper;
      _imagenAsset = data.imagenAsset;
      _slots = List.filled(upper.length, null);
      _available = shuffled;
      _shakingSlot = null;
      _hoverSlot = null;
      _showCelebration = false;
    });
  }

  void _onLetterDropped(int slotIndex, int availableIndex) {
    final letter = _available[availableIndex];
    if (letter == null || _slots[slotIndex] != null) return;

    if (letter == _currentWord[slotIndex]) {
      _playSound('audio/fanfare.mp3');
      setState(() {
        _slots[slotIndex] = letter;
        _available[availableIndex] = null;
        _hoverSlot = null;
      });
      if (_slots.every((s) => s != null)) _onWordCompleted();
    } else {
      setState(() {
        _shakingSlot = slotIndex;
        _hoverSlot = null;
      });
      _playSound('audio/boing.mp3');
      _shakeController.forward(from: 0).then((_) {
        if (mounted) setState(() => _shakingSlot = null);
      });
    }
  }

  Future<void> _onWordCompleted() async {
    setState(() {
      _showCelebration = true;
      _completedWords++;
    });
    SessionTracker.instance.recordStars(1);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    if (_completedWords >= _wordsToWin) {
      setState(() => _showResults = true);
    } else {
      _loadNewWord();
    }
  }

  void _revealHint() {
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        final correctLetter = _currentWord[i];
        final availIdx = _available.indexWhere((l) => l == correctLetter);
        if (availIdx != -1) {
          setState(() {
            _slots[i] = correctLetter;
            _available[availIdx] = null;
          });
          if (_slots.every((s) => s != null)) _onWordCompleted();
        }
        return;
      }
    }
  }

  void _playAgain() {
    setState(() {
      _completedWords = 0;
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
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _ResultsScreen(
        completedWords: _completedWords,
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
          '$_completedWords ✓',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: _revealHint,
            tooltip: 'Pista',
            icon: const Text('💡', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: _ImageDisplay(imagenAsset: _imagenAsset),
                  ),
                  const SizedBox(height: 24),
                  _SlotsRow(
                    slots: _slots,
                    word: _currentWord,
                    shakingSlot: _shakingSlot,
                    hoverSlot: _hoverSlot,
                    shakeAnimation: _shakeAnimation,
                    shakeController: _shakeController,
                    onLetterDropped: _onLetterDropped,
                    onHoverChanged: (idx, hovering) =>
                        setState(() => _hoverSlot = hovering ? idx : null),
                  ),
                  const SizedBox(height: 32),
                  _AvailableLetters(available: _available),
                ],
              ),
            ),
            if (_showCelebration) _CelebrationOverlay(word: _currentWord),
          ],
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

class _SlotsRow extends StatelessWidget {
  const _SlotsRow({
    required this.slots,
    required this.word,
    required this.shakingSlot,
    required this.hoverSlot,
    required this.shakeAnimation,
    required this.shakeController,
    required this.onLetterDropped,
    required this.onHoverChanged,
  });

  final List<String?> slots;
  final String word;
  final int? shakingSlot;
  final int? hoverSlot;
  final Animation<double> shakeAnimation;
  final AnimationController shakeController;
  final void Function(int slotIndex, int availableIndex) onLetterDropped;
  final void Function(int slotIndex, bool hovering) onHoverChanged;

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
              child: AnimatedBuilder(
                animation: shakeController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    shakingSlot == i ? shakeAnimation.value : 0.0,
                    0,
                  ),
                  child: child,
                ),
                child: DragTarget<int>(
                  onWillAcceptWithDetails: (details) => slots[i] == null,
                  onAcceptWithDetails: (details) =>
                      onLetterDropped(i, details.data),
                  onMove: (_) => onHoverChanged(i, true),
                  onLeave: (_) => onHoverChanged(i, false),
                  builder: (context, candidateData, rejectedData) {
                    final isHovered = hoverSlot == i;
                    final filled = slots[i];
                    return _SlotTile(
                      letter: filled,
                      isHovered: isHovered && filled == null,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({required this.letter, required this.isHovered});
  final String? letter;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final filled = letter != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 60,
      height: 64,
      decoration: BoxDecoration(
        color: filled
            ? AppTheme.secondary.withValues(alpha: 0.2)
            : isHovered
                ? AppTheme.gamesColor.withValues(alpha: 0.25)
                : AppTheme.gamesColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: filled
              ? AppTheme.secondary
              : isHovered
                  ? AppTheme.gamesColor
                  : AppTheme.gamesColor.withValues(alpha: 0.5),
          width: filled ? 2 : 2.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Text(
          filled ? letter! : '_',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: filled ? AppTheme.secondary : AppTheme.gamesColor,
          ),
        ),
      ),
    );
  }
}

class _AvailableLetters extends StatelessWidget {
  const _AvailableLetters({required this.available});
  final List<String?> available;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (int i = 0; i < available.length; i++)
          if (available[i] != null)
            Draggable<int>(
              data: i,
              feedback: Material(
                color: Colors.transparent,
                child: Transform.scale(
                  scale: 1.2,
                  child: _LetterTile(letter: available[i]!),
                ),
              ),
              childWhenDragging: _LetterTile(
                letter: available[i]!,
                muted: true,
              ),
              child: _LetterTile(letter: available[i]!),
            ),
      ],
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({required this.letter, this.muted = false});
  final String letter;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: muted
            ? AppTheme.gamesColor.withValues(alpha: 0.3)
            : AppTheme.gamesColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: muted
            ? null
            : [
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
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: muted ? Colors.white54 : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _CelebrationOverlay extends StatelessWidget {
  const _CelebrationOverlay({required this.word});
  final String word;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🦁', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 8),
              const Text(
                '¡Bien hecho! ⭐',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                word,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gamesColor,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsScreen extends StatelessWidget {
  const _ResultsScreen({
    required this.completedWords,
    required this.onPlayAgain,
    required this.onExit,
  });
  final int completedWords;
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
                child: LeoMascot(state: LeoState.celebrating, size: 80),
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
                '$completedWords ✓',
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
