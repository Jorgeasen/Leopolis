import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/database/session_tracker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/asset_image_with_fallback.dart';
import '../../../shared/widgets/celebration_overlay.dart';
import '../../../shared/widgets/leo_mascot.dart';
import '../../rewards/data/rewards_provider.dart';
import '../data/word_data.dart';
import '../data/words_repository.dart';

class SyllableBuildScreen extends ConsumerStatefulWidget {
  const SyllableBuildScreen({super.key});

  @override
  ConsumerState<SyllableBuildScreen> createState() =>
      _SyllableBuildScreenState();
}

class _SyllableBuildScreenState extends ConsumerState<SyllableBuildScreen>
    with TickerProviderStateMixin {
  static const int _wordsToWin = 8;

  final _rng = Random();
  final _tts = FlutterTts();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  late WordData _currentWord;
  late List<String?> _slots;
  late List<String?> _available;
  int? _shakingSlot;
  int _completedWords = 0;
  bool _perfectThisWord = true;
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
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    _configureTts();
    _loadNewWord();
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
    } finally {
      if (mounted) _speaking = false;
    }
  }

  List<WordData> _eligibleWords() {
    final all = WordsRepository.getAll()
        .where((w) => w.silabas.length >= 2 && w.silabas.length <= 4)
        .toList();
    if (_completedWords < 3) {
      final two = all.where((w) => w.silabas.length == 2).toList();
      if (two.isNotEmpty) return two;
    } else if (_completedWords < 6) {
      final three = all.where((w) => w.silabas.length == 3).toList();
      if (three.isNotEmpty) return three;
    } else {
      final four = all.where((w) => w.silabas.length >= 4).toList();
      if (four.isNotEmpty) return four;
    }
    return all;
  }

  void _loadNewWord() {
    final words = _eligibleWords()..shuffle(_rng);
    final word = words.first;
    final shuffled = List<String?>.from(word.silabas)..shuffle(_rng);

    setState(() {
      _currentWord = word;
      _slots = List.filled(word.silabas.length, null);
      _available = shuffled;
      _shakingSlot = null;
      _perfectThisWord = true;
    });

    Future.microtask(() => _speak(word.palabra));
  }

  void _onSyllableTap(int availableIdx) {
    final syllable = _available[availableIdx];
    if (syllable == null || _shakingSlot != null) return;

    final firstFreeSlot = _slots.indexWhere((s) => s == null);
    if (firstFreeSlot == -1) return;

    setState(() {
      _slots[firstFreeSlot] = syllable;
      _available[availableIdx] = null;
    });

    if (syllable == _currentWord.silabas[firstFreeSlot]) {
      AudioService.instance.playSuccess();
      if (_slots.every((s) => s != null)) _onWordCompleted();
    } else {
      _perfectThisWord = false;
      AudioService.instance.playError();
      setState(() => _shakingSlot = firstFreeSlot);
      _shakeController.forward(from: 0).then((_) {
        if (mounted) {
          setState(() {
            _slots[firstFreeSlot] = null;
            _available[availableIdx] = syllable;
            _shakingSlot = null;
          });
        }
      });
    }
  }

  void _onSlotTap(int slotIdx) {
    if (_slots[slotIdx] == null || _shakingSlot != null) return;

    // Return this slot and all subsequent slots to available (cascade)
    setState(() {
      for (int i = slotIdx; i < _slots.length; i++) {
        final s = _slots[i];
        if (s != null) {
          final freeIdx = _available.indexWhere((a) => a == null);
          if (freeIdx != -1) _available[freeIdx] = s;
          _slots[i] = null;
        }
      }
    });
  }

  Future<void> _onWordCompleted() async {
    if (_perfectThisWord) {
      SessionTracker.instance.recordStars(1);
      ref.read(rewardsProvider.notifier).addStars(1);
    }
    if (mounted) CelebrationOverlay.show(context);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    setState(() => _completedWords++);
    if (_completedWords >= _wordsToWin) {
      setState(() => _showResults = true);
    } else {
      _loadNewWord();
    }
  }

  void _playAgain() {
    setState(() {
      _completedWords = 0;
      _showResults = false;
    });
    _loadNewWord();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _ResultsScreen(
        completedWords: _completedWords,
        onPlayAgain: _playAgain,
        onExit: () => context.go('/words'),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.wordsColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/words'),
          tooltip: 'Volver',
        ),
        title: Text(
          '$_completedWords / $_wordsToWin',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () => _speak(_currentWord.palabra),
            tooltip: 'Escuchar',
            icon: const Icon(Icons.volume_up_rounded, size: 28),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: _ImageDisplay(
                  imagenAsset: _currentWord.imagenAsset,
                  emoji: _currentWord.emoji,
                ),
              ),
              const SizedBox(height: 24),
              _SlotsRow(
                slots: _slots,
                silabas: _currentWord.silabas,
                shakingSlot: _shakingSlot,
                shakeAnimation: _shakeAnimation,
                shakeController: _shakeController,
                onSlotTap: _onSlotTap,
              ),
              const SizedBox(height: 32),
              _AvailableSyllables(
                available: _available,
                onTap: _onSyllableTap,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _ImageDisplay extends StatelessWidget {
  const _ImageDisplay({required this.imagenAsset, required this.emoji});
  final String imagenAsset;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.wordsColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AssetImageWithFallback(
        assetPath: imagenAsset,
        fallbackEmoji: emoji.isEmpty ? '🖼️' : emoji,
        emojiFontSize: 100,
      ),
    );
  }
}

class _SlotsRow extends StatelessWidget {
  const _SlotsRow({
    required this.slots,
    required this.silabas,
    required this.shakingSlot,
    required this.shakeAnimation,
    required this.shakeController,
    required this.onSlotTap,
  });

  final List<String?> slots;
  final List<String> silabas;
  final int? shakingSlot;
  final Animation<double> shakeAnimation;
  final AnimationController shakeController;
  final void Function(int) onSlotTap;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < silabas.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: AnimatedBuilder(
                animation: shakeController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    shakingSlot == i ? shakeAnimation.value : 0.0,
                    0,
                  ),
                  child: child,
                ),
                child: GestureDetector(
                  onTap: () => onSlotTap(i),
                  child: _SlotTile(letter: slots[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({required this.letter});
  final String? letter;

  @override
  Widget build(BuildContext context) {
    final filled = letter != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: const BoxConstraints(minWidth: 72, minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled
            ? AppTheme.secondary.withValues(alpha: 0.2)
            : AppTheme.wordsColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: filled
              ? AppTheme.secondary
              : AppTheme.wordsColor.withValues(alpha: 0.4),
          width: 2.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Text(
          filled ? letter!.toUpperCase() : '___',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: filled
                ? AppTheme.secondary
                : AppTheme.wordsColor.withValues(alpha: 0.4),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _AvailableSyllables extends StatelessWidget {
  const _AvailableSyllables({
    required this.available,
    required this.onTap,
  });

  final List<String?> available;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (int i = 0; i < available.length; i++)
          if (available[i] != null)
            GestureDetector(
              onTap: () => onTap(i),
              child: _SyllableTile(syllable: available[i]!),
            ),
      ],
    );
  }
}

class _SyllableTile extends StatelessWidget {
  const _SyllableTile({required this.syllable});
  final String syllable;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 72, minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
