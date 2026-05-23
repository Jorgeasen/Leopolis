import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class LettersScreen extends ConsumerStatefulWidget {
  const LettersScreen({super.key});

  @override
  ConsumerState<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends ConsumerState<LettersScreen> {
  final FlutterTts _tts = FlutterTts();
  String? _selectedLetter;

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.4);  // Lento para que Leo entienda bien
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);       // Tono ligeramente agudo, más amigable
  }

  Future<void> _speakLetter(String letter) async {
    setState(() => _selectedLetter = letter);
    await _tts.speak(letter);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.lettersColor,
        foregroundColor: Colors.white,
        title: const Text('Las Letras 🔤',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppConstants.routeHome),
        ),
      ),
      body: Column(
        children: [
          // Letra seleccionada en grande
          if (_selectedLetter != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppTheme.lettersColor.withValues(alpha: 0.1),
              child: Center(
                child: Text(
                  _selectedLetter!,
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lettersColor,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            '¡Toca una letra para escucharla!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          // Grid de letras
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: AppConstants.spanishAlphabet.length,
                itemBuilder: (context, index) {
                  final letter = AppConstants.spanishAlphabet[index];
                  final isSelected = letter == _selectedLetter;
                  return GestureDetector(
                    onTap: () => _speakLetter(letter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lettersColor
                            : AppTheme.lettersColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lettersColor,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.lettersColor,
                          ),
                        ),
                      ),
                    ),
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
