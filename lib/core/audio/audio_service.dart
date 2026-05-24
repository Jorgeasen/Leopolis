import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  final FlutterTts _tts = FlutterTts();
  bool _soundEnabled = true;

  // Serializa llamadas: evita que dos speak() simultáneos provoquen el
  // callback nativo de flutter_tts en un hilo incorrecto (bug Android).
  bool _busy = false;

  void setSoundEnabled(bool enabled) => _soundEnabled = enabled;

  Future<void> playSuccess() async {
    if (!_soundEnabled || _busy) return;
    _busy = true;
    try {
      // unawaited: no esperamos el callback de stop() para evitar el hilo nativo
      unawaited(_tts.stop());
      await Future.delayed(const Duration(milliseconds: 50));
      await _tts.setLanguage('es-ES');
      await _tts.setSpeechRate(0.6);
      await _tts.setPitch(1.4);
      await _tts.speak('Bien');
    } catch (_) {}
    // Mantener busy durante la duración de "Bien" antes de liberar
    await Future.delayed(const Duration(milliseconds: 500));
    _busy = false;
  }

  Future<void> playError() async {
    if (!_soundEnabled || _busy) return;
    _busy = true;
    try {
      // unawaited: no esperamos el callback de stop() para evitar el hilo nativo
      unawaited(_tts.stop());
      await Future.delayed(const Duration(milliseconds: 50));
      await _tts.setLanguage('es-ES');
      await _tts.setSpeechRate(0.6);
      await _tts.setPitch(0.7);
      await _tts.speak('No');
    } catch (_) {}
    // Mantener busy ~350ms (duración de "No") → taps rápidos: suena cada ~400ms
    await Future.delayed(const Duration(milliseconds: 350));
    _busy = false;
  }
}
