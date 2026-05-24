import 'package:flutter/widgets.dart';
import 'collections/session_data.dart';
import 'isar_service.dart';

class SessionTracker with WidgetsBindingObserver {
  static final SessionTracker instance = SessionTracker._();
  SessionTracker._();

  SessionData? _current;

  /// Llama una vez en main.dart tras abrir Isar.
  void start() {
    WidgetsBinding.instance.addObserver(this);
    _openSession();
  }

  void _openSession() {
    _current = SessionData()..startTime = DateTime.now();
  }

  void recordStars(int count) {
    if (_current != null) _current!.starsEarned += count;
  }

  void recordLetter(String letter) {
    final s = _current;
    if (s != null && !s.lettersAttempted.contains(letter)) {
      s.lettersAttempted = [...s.lettersAttempted, letter];
    }
  }

  Future<void> _saveAndReset() async {
    final session = _current;
    if (session == null) return;
    _current = null;

    session.endTime = DateTime.now();
    // Solo persistir si hubo actividad real
    if (session.starsEarned == 0 && session.lettersAttempted.isEmpty) return;

    try {
      final db = IsarService.instance.db;
      await db.writeTxn(() => db.sessionDatas.put(session));
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveAndReset().then((_) => _openSession());
    }
  }
}
