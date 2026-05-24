import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/session_tracker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/tracing_canvas.dart';
import '../data/letters_progress_provider.dart';
import '../data/letters_repository.dart';

class LetterTracingScreen extends ConsumerStatefulWidget {
  const LetterTracingScreen({super.key, required this.letter});

  final String letter;

  @override
  ConsumerState<LetterTracingScreen> createState() =>
      _LetterTracingScreenState();
}

class _LetterTracingScreenState extends ConsumerState<LetterTracingScreen>
    with TickerProviderStateMixin {
  final _canvasKey = GlobalKey<TracingCanvasState>();

  late final AnimationController _starCtrl;
  late final Animation<double> _starScale;
  late final Animation<double> _starOpacity;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeOffset;

  bool _succeeded = false;
  String _message = '';

  @override
  void initState() {
    super.initState();

    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _starScale = CurvedAnimation(parent: _starCtrl, curve: Curves.elasticOut);
    _starOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _starCtrl,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      ),
    );

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -16), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -16, end: 16), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 16, end: -12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: 0), weight: 1),
    ]).animate(_shakeCtrl);
  }

  @override
  void dispose() {
    _starCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSuccess() async {
    setState(() {
      _succeeded = true;
      _message = '¡Muy bien! ⭐';
    });
    _starCtrl.forward(from: 0);
    await AudioService.instance.playSuccess();
    await ref
        .read(lettersProgressProvider.notifier)
        .markCompleted(widget.letter);
    SessionTracker.instance.recordLetter(widget.letter);
    SessionTracker.instance.recordStars(AppConstants.starsPerExercise);
  }

  void _onFailure() {
    setState(() => _message = '¡Inténtalo otra vez! 🦁');
    _shakeCtrl.forward(from: 0);
    AudioService.instance.playError();
  }

  void _reset() {
    _canvasKey.currentState?.clear();
    setState(() {
      _succeeded = false;
      _message = '';
    });
    _starCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final next = LettersRepository.getNext(widget.letter);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.lettersColor,
        foregroundColor: Colors.white,
        title: Text(
          'Trazar la ${widget.letter}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/letters/${widget.letter}'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Traza la letra 🖊️',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _shakeOffset,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(_shakeOffset.value, 0),
                      child: child,
                    ),
                    child: TracingCanvas(
                      key: _canvasKey,
                      letter: widget.letter,
                      canvasSize: const Size(280, 280),
                      onSuccess: _onSuccess,
                      onFailure: _onFailure,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildFeedback(),
              const SizedBox(height: 12),
              if (_succeeded && next != null)
                _ActionButton(
                  label: 'Siguiente letra  ▶',
                  color: AppTheme.secondary,
                  onTap: () => context.go('/letters/${next.letra}/tracing'),
                )
              else if (!_succeeded)
                _ActionButton(
                  label: '🔄 Volver a intentar',
                  color: AppTheme.lettersColor.withValues(alpha: 0.8),
                  onTap: _reset,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    if (_message.isEmpty) return const SizedBox(height: 56);

    if (_succeeded) {
      return FadeTransition(
        opacity: _starOpacity,
        child: ScaleTransition(
          scale: _starScale,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.secondary),
            ),
            child: Center(
              child: Text(
                _message,
                style: const TextStyle(
                  fontSize: 22,
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
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Text(
          _message,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
