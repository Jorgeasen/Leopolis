import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/session_tracker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/leo_mascot.dart';

class FallingLettersGame extends StatefulWidget {
  const FallingLettersGame({super.key});

  @override
  State<FallingLettersGame> createState() => _FallingLettersGameState();
}

class _FallingLettersGameState extends State<FallingLettersGame>
    with SingleTickerProviderStateMixin {
  static const double _letterSize = 72.0;
  static const double _initialFallDuration = 4.0;
  static const double _minFallDuration = 2.0;
  static const int _spawnIntervalMs = 1400;
  static const int _maxLetters = 8;

  final _rng = Random();
  late final Ticker _ticker;
  int _idCounter = 0;

  Duration _lastElapsed = Duration.zero;
  Duration _lastSpawn = Duration.zero;

  final List<_FallingLetter> _letters = [];
  String _target = 'A';
  int _stars = 0;
  int _correctCount = 0;
  double _fallDuration = _initialFallDuration;
  bool _paused = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _pickTarget();
    _ticker = createTicker(_onTick)..start();
  }

  void _pickTarget() {
    const alpha = AppConstants.spanishAlphabet;
    String next;
    do {
      next = alpha[_rng.nextInt(alpha.length)];
    } while (next == _target && alpha.length > 1);
    _target = next;
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    if (_paused || _showResults) {
      _lastElapsed = elapsed;
      _lastSpawn = elapsed;
      return;
    }

    final deltaT = (elapsed - _lastElapsed).inMilliseconds / 1000.0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    _lastElapsed = elapsed;

    setState(() {
      for (final l in _letters) {
        if (l.exploding) {
          l.explodeT = (l.explodeT + deltaT / 0.4).clamp(0.0, 1.0);
        } else {
          l.progress = (l.progress + deltaT / _fallDuration).clamp(0.0, 1.1);
        }
        if (l.shakeStartMs != null && nowMs - l.shakeStartMs! > 350) {
          l.shakeStartMs = null;
        }
      }
      _letters.removeWhere(
        (l) => l.progress >= 1.0 || (l.exploding && l.explodeT >= 1.0),
      );

      if ((elapsed - _lastSpawn).inMilliseconds >= _spawnIntervalMs &&
          _letters.length < _maxLetters) {
        _spawnLetter();
        _lastSpawn = elapsed;
      }
    });
  }

  void _spawnLetter() {
    const alpha = AppConstants.spanishAlphabet;
    final letter =
        _rng.nextDouble() < 0.35 ? _target : alpha[_rng.nextInt(alpha.length)];
    _letters.add(_FallingLetter(
      id: '${_idCounter++}',
      letter: letter,
      x: 0.06 + _rng.nextDouble() * 0.82,
    ));
  }

  void _onLetterTap(_FallingLetter letter) {
    if (letter.exploding) return;
    if (letter.letter == _target) {
      setState(() {
        letter.exploding = true;
        _stars++;
        _correctCount++;
        SessionTracker.instance.recordStars(1);
        if (_correctCount % 5 == 0) {
          _fallDuration = (_fallDuration * 0.9)
              .clamp(_minFallDuration, _initialFallDuration);
        }
        _pickTarget();
      });
      AudioService.instance.playSuccess();
    } else {
      setState(
        () => letter.shakeStartMs = DateTime.now().millisecondsSinceEpoch,
      );
      AudioService.instance.playError();
    }
  }

  void _togglePause() => setState(() => _paused = !_paused);

  void _endGame() => setState(() {
        _paused = false;
        _showResults = true;
      });

  void _playAgain() {
    setState(() {
      _letters.clear();
      _stars = 0;
      _correctCount = 0;
      _fallDuration = _initialFallDuration;
      _paused = false;
      _showResults = false;
    });
    _pickTarget();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
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
          '⭐ $_stars',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          if (!_showResults)
            IconButton(
              icon: Icon(
                _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              ),
              iconSize: 32,
              onPressed: _togglePause,
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _TargetBubble(target: _target),
                Expanded(
                  child: _GameArea(
                    letters: _letters,
                    letterSize: _letterSize,
                    nowMs: nowMs,
                    onLetterTap: _onLetterTap,
                  ),
                ),
              ],
            ),
            if (_paused && !_showResults)
              _PauseOverlay(onContinue: _togglePause, onEnd: _endGame),
            if (_showResults)
              _ResultsOverlay(
                stars: _stars,
                onPlayAgain: _playAgain,
                onExit: () => context.go('/games'),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _TargetBubble extends StatelessWidget {
  const _TargetBubble({required this.target});
  final String target;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      color: AppTheme.gamesColor.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🦁', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 12),
          const Text(
            'Toca la: ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          Text(
            target,
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: AppTheme.gamesColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _GameArea extends StatelessWidget {
  const _GameArea({
    required this.letters,
    required this.letterSize,
    required this.nowMs,
    required this.onLetterTap,
  });

  final List<_FallingLetter> letters;
  final double letterSize;
  final int nowMs;
  final void Function(_FallingLetter) onLetterTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            for (final letter in letters)
              Positioned(
                left:
                    (letter.x * w - letterSize / 2).clamp(0.0, w - letterSize),
                top: (letter.progress * (h - letterSize)).clamp(0.0, h),
                child: _buildLetterWidget(letter),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLetterWidget(_FallingLetter letter) {
    final tile = GestureDetector(
      onTap: () => onLetterTap(letter),
      child: _LetterTile(letter: letter.letter, size: letterSize),
    );

    if (letter.exploding) {
      final t = letter.explodeT.clamp(0.0, 1.0);
      return Transform.scale(
        scale: 1.0 + t * 1.5,
        child: Opacity(opacity: (1.0 - t).clamp(0.0, 1.0), child: tile),
      );
    }

    if (letter.shakeStartMs != null) {
      final elapsedSec = (nowMs - letter.shakeStartMs!) / 1000.0;
      if (elapsedSec < 0.35) {
        final shakeX =
            sin(elapsedSec * pi * 16) * 12 * (1.0 - elapsedSec / 0.35);
        return Transform.translate(offset: Offset(shakeX, 0), child: tile);
      }
    }

    return tile;
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({required this.letter, required this.size});
  final String letter;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  const _PauseOverlay({required this.onContinue, required this.onEnd});
  final VoidCallback onContinue;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '⏸  ¡En pausa!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gamesColor,
                  ),
                  child: const Text(
                    '▶  Continuar',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 64,
                child: OutlinedButton(
                  onPressed: onEnd,
                  child: const Text(
                    'Ver resultados',
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

class _ResultsOverlay extends StatelessWidget {
  const _ResultsOverlay({
    required this.stars,
    required this.onPlayAgain,
    required this.onExit,
  });
  final int stars;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
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
            '$stars ⭐',
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
    );
  }
}

// ── Data model ───────────────────────────────────────────────────────────────

class _FallingLetter {
  _FallingLetter({
    required this.id,
    required this.letter,
    required this.x,
  });

  final String id;
  final String letter;
  final double x;
  double progress = 0.0;
  bool exploding = false;
  double explodeT = 0.0;
  int? shakeStartMs;
}
