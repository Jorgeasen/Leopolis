import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  final FlutterTts _tts = FlutterTts();

  Future<void> playSuccess() async {
    try {
      await _tts.setLanguage('es-ES');
      await _tts.setSpeechRate(0.6);
      await _tts.setPitch(1.4);
      await _tts.speak('¡Muy bien!');
    } catch (_) {}
  }

  Future<void> playError() async {
    try {
      await _tts.setLanguage('es-ES');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(0.7);
      await _tts.speak('¡Inténtalo!');
    } catch (_) {}
  }
}
