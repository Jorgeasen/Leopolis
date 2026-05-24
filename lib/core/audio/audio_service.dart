import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  final FlutterTts _tts = FlutterTts();
  bool _soundEnabled = true;

  void setSoundEnabled(bool enabled) => _soundEnabled = enabled;

  Future<void> playSuccess() async {
    if (!_soundEnabled) return;
    try {
      await _tts.setLanguage('es-ES');
      await _tts.setSpeechRate(0.6);
      await _tts.setPitch(1.4);
      await _tts.speak('¡Muy bien!');
    } catch (_) {}
  }

  Future<void> playError() async {
    if (!_soundEnabled) return;
    try {
      await _tts.setLanguage('es-ES');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(0.7);
      await _tts.speak('¡Inténtalo!');
    } catch (_) {}
  }
}
