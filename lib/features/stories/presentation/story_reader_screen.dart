import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/asset_image_with_fallback.dart';
import '../../../shared/widgets/leo_mascot.dart';
import '../data/stories_read_provider.dart';
import '../data/stories_repository.dart';
import '../data/story_data.dart';

class StoryReaderScreen extends ConsumerStatefulWidget {
  const StoryReaderScreen({super.key, required this.storyId});

  final String storyId;

  @override
  ConsumerState<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends ConsumerState<StoryReaderScreen> {
  late final StoryData _story;
  late final PageController _pageController;
  final FlutterTts _tts = FlutterTts();

  int _pageIndex = 0;
  int? _highlightedWord;
  bool _speaking = false;
  bool _showNextHint = false;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    final story = StoriesRepository.getById(widget.storyId);
    _story = story ??
        const StoryData(
          id: '',
          titulo: '',
          emoji: '📖',
          paginas: [
            StoryPage(
                frase: '🦁 ¡Vamos a intentarlo otra vez!',
                imagenAsset: '',
                emoji: '🦁'),
          ],
        );
    _pageController = PageController();
    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
  }

  StoryPage get _currentPage => _story.paginas[_pageIndex];

  Future<void> _speakWithHighlight() async {
    if (_speaking) {
      unawaited(_tts.stop());
      _speaking = false;
      _autoAdvanceTimer?.cancel();
      setState(() {
        _highlightedWord = null;
        _showNextHint = false;
      });
      return;
    }

    final frase = _currentPage.frase;
    final words = frase.split(' ');
    _speaking = true;
    _autoAdvanceTimer?.cancel();
    setState(() {
      _highlightedWord = null;
      _showNextHint = false;
    });

    try {
      _tts.speak(frase);
      await Future.delayed(const Duration(milliseconds: 120));

      for (int i = 0; i < words.length; i++) {
        if (!mounted || !_speaking) break;
        setState(() => _highlightedWord = i);
        final letterCount =
            words[i].replaceAll(RegExp(r'[^a-záéíóúüñA-ZÁÉÍÓÚÜÑ]'), '').length;
        final delay = (200 * letterCount).clamp(150, 900);
        await Future.delayed(Duration(milliseconds: delay));
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _highlightedWord = null);
        _speaking = false;
        _startAutoAdvanceTimer();
      }
    }
  }

  void _speakWord(String word) {
    if (_speaking) return;
    _tts.speak(word);
  }

  void _startAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
    if (_pageIndex < _story.paginas.length - 1) {
      _autoAdvanceTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) setState(() => _showNextHint = true);
      });
    }
  }

  void _onPageChanged(int index) {
    unawaited(_tts.stop());
    _speaking = false;
    _autoAdvanceTimer?.cancel();
    setState(() {
      _pageIndex = index;
      _highlightedWord = null;
      _showNextHint = false;
    });

    if (index == _story.paginas.length - 1) {
      ref.read(storiesReadProvider.notifier).markRead(_story.id);
    }
  }

  void _previousPage() {
    if (_pageIndex > 0) {
      _pageController.animateToPage(
        _pageIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_pageIndex < _story.paginas.length - 1) {
      _pageController.animateToPage(
        _pageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoAdvanceTimer?.cancel();
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_story.id.isEmpty) {
      return _ErrorScreen(onBack: () => context.go('/stories'));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.storiesColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/stories'),
          tooltip: 'Volver',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _story.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Página ${_pageIndex + 1} de ${_story.paginas.length}',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _story.paginas.length,
              itemBuilder: (context, index) => _PageContent(
                page: _story.paginas[index],
                highlightedWord: index == _pageIndex ? _highlightedWord : null,
                onWordTap: _speakWord,
              ),
            ),
          ),
          _BottomBar(
            pageIndex: _pageIndex,
            totalPages: _story.paginas.length,
            speaking: _speaking,
            showNextHint: _showNextHint,
            onPrevious: _previousPage,
            onSpeak: _speakWithHighlight,
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}

// ── Page content ─────────────────────────────────────────────────────────────

class _PageContent extends StatelessWidget {
  const _PageContent({
    required this.page,
    required this.highlightedWord,
    required this.onWordTap,
  });

  final StoryPage page;
  final int? highlightedWord;
  final void Function(String) onWordTap;

  static String? _searchTermFromFrase(String frase) {
    const skip = {
      'el',
      'la',
      'los',
      'las',
      'un',
      'una',
      'unos',
      'unas',
      'a',
      'al',
      'de',
      'del',
      'en',
      'y',
      'se',
      'no',
      'su',
      'sus',
      'que',
      'hay',
      'es',
      'son',
      'está',
      'están',
      'llega',
      'llegan',
      'cae',
      'nada',
      'vive',
      'tiene',
      'llama',
      've',
      'brilla',
      'abren',
      'beben',
      'vuelve',
    };
    final words = frase
        .replaceAll(RegExp(r'[^\w\sáéíóúüñÁÉÍÓÚÜÑ]'), '')
        .split(' ')
        .map((w) => w.toLowerCase().trim())
        .where((w) => w.length > 2 && !skip.contains(w))
        .toList();
    return words.isNotEmpty ? words.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final words = page.frase.split(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.storiesColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: AssetImageWithFallback(
                assetPath: page.imagenAsset,
                fallbackEmoji: page.emoji.isEmpty ? '📖' : page.emoji,
                emojiFontSize: 100,
                searchTerm: _searchTermFromFrase(page.frase),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (int i = 0; i < words.length; i++)
                    GestureDetector(
                      onTap: () => onWordTap(
                        words[i]
                            .replaceAll(RegExp(r'[^\w\sáéíóúüñÁÉÍÓÚÜÑ]'), ''),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        constraints: const BoxConstraints(minHeight: 44),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: highlightedWord == i
                              ? AppTheme.accent.withValues(alpha: 0.75)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          words[i],
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                            fontFamily: 'Fredoka',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.pageIndex,
    required this.totalPages,
    required this.speaking,
    required this.showNextHint,
    required this.onPrevious,
    required this.onSpeak,
    required this.onNext,
  });

  final int pageIndex;
  final int totalPages;
  final bool speaking;
  final bool showNextHint;
  final VoidCallback onPrevious;
  final VoidCallback onSpeak;
  final VoidCallback onNext;

  bool get _isLast => pageIndex >= totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _NavButton(
              icon: Icons.arrow_back_ios_rounded,
              label: 'Anterior',
              enabled: pageIndex > 0,
              onTap: onPrevious,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: onSpeak,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: speaking
                        ? AppTheme.storiesColor.withValues(alpha: 0.6)
                        : AppTheme.storiesColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: Icon(
                    speaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                    size: 26,
                  ),
                  label: Text(
                    speaking ? 'Parar' : 'Leer',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _NavButton(
              icon: Icons.arrow_forward_ios_rounded,
              label: _isLast ? '¡Listo!' : 'Siguiente',
              enabled: !_isLast,
              highlighted: showNextHint,
              onTap: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? (highlighted ? AppTheme.primary : AppTheme.storiesColor)
        : AppTheme.textDark.withValues(alpha: 0.25);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minWidth: 72, minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: highlighted
              ? AppTheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: highlighted
              ? Border.all(color: AppTheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error screen ──────────────────────────────────────────────────────────────

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LeoMascot(state: LeoState.encouraging, size: 80),
              const SizedBox(height: 16),
              const Text(
                '¡Vamos a intentarlo otra vez! 🦁',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: onBack,
                  child: const Text('← Volver', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
