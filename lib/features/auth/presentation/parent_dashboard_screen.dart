import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/collections/letter_progress.dart';
import '../../../core/database/collections/rewards_data.dart';
import '../../../core/database/collections/session_data.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/firebase/firebase_service.dart';
import '../../../core/theme/app_theme.dart';
import '../data/auth_repository.dart';

class _DashboardData {
  const _DashboardData({
    required this.lettersCompleted,
    required this.rewards,
    required this.sessions,
  });

  final List<LetterProgress> lettersCompleted;
  final RewardsData? rewards;
  final List<SessionData> sessions;

  int get totalLetters => AppConstants.spanishAlphabet.length;
  int get completedCount => lettersCompleted.length;
  double get lettersPercent =>
      totalLetters > 0 ? completedCount / totalLetters : 0.0;

  Duration get totalSessionTime {
    return sessions.fold(Duration.zero, (acc, s) {
      if (s.endTime == null) return acc;
      return acc + s.endTime!.difference(s.startTime);
    });
  }

  SessionData? get lastSession => sessions.isNotEmpty ? sessions.first : null;

  Duration get lastSessionDuration {
    final last = lastSession;
    if (last == null || last.endTime == null) return Duration.zero;
    return last.endTime!.difference(last.startTime);
  }

  List<int> get weeklyMinutes {
    final now = DateTime.now();
    final weeks = List.filled(5, 0);
    for (final s in sessions) {
      if (s.endTime == null) continue;
      final mins = s.endTime!.difference(s.startTime).inMinutes;
      final weeksAgo = now.difference(s.startTime).inDays ~/ 7;
      if (weeksAgo < 5) weeks[4 - weeksAgo] += mins;
    }
    return weeks;
  }
}

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  _DashboardData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final db = IsarService.instance.db;
    final letters = await db.letterProgress.where().anyId().findAll();
    final completed = letters.where((l) => l.isCompleted).toList();
    final rewards = await db.rewardsDatas.where().anyId().findFirst();
    final rawSessions = await db.sessionDatas.where().anyId().findAll();
    final sessions = rawSessions
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    if (!mounted) return;
    setState(() {
      _data = _DashboardData(
        lettersCompleted: completed,
        rewards: rewards,
        sessions: sessions,
      );
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    await AuthRepository.instance.signOut();
    if (!mounted) return;
    context.go(AppConstants.routeRewards);
  }

  Future<void> _resetProgress() async {
    final first = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Reiniciar progreso?'),
        content: const Text(
          'Se borrarán todas las letras, estrellas y sesiones de Leo.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (first != true || !mounted) return;

    final second = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('⚠️ Confirmar reset'),
        content: const Text(
          'Esta acción no se puede deshacer.\n¿Seguro que quieres borrar todo el progreso de Leo?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, borrar todo'),
          ),
        ],
      ),
    );
    if (second != true || !mounted) return;

    final db = IsarService.instance.db;
    await db.writeTxn(() async {
      await db.letterProgress.where().anyId().deleteAll();
      await db.rewardsDatas.where().anyId().deleteAll();
      await db.sessionDatas.where().anyId().deleteAll();
    });
    await _loadData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progreso reiniciado ✓'),
        backgroundColor: AppTheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.rewardsColor,
        foregroundColor: AppTheme.textDark,
        title: const Text(
          'Progreso de Leo 📊',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppConstants.routeRewards),
        ),
        actions: [
          if (FirebaseService.instance.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Cerrar sesión',
              onPressed: _signOut,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    final data = _data!;

    if (!FirebaseService.instance.isAuthenticated) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🦁', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              const Text(
                'Inicia sesión para ver el progreso',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: AppTheme.textDark),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: () => context.go('/parent-login'),
                  child: const Text('Iniciar sesión con Google'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final user = FirebaseService.instance.auth.currentUser;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _GreetingCard(
              name: user?.displayName?.split(' ').first ?? 'Papá/Mamá'),
          const SizedBox(height: 16),
          _LettersCard(data: data),
          const SizedBox(height: 16),
          _StarsCard(data: data),
          const SizedBox(height: 16),
          _SessionsCard(data: data),
          const SizedBox(height: 16),
          _WeeklyChart(weeklyMinutes: data.weeklyMinutes),
          const SizedBox(height: 24),
          _ResetButton(onReset: _resetProgress),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.rewardsColor, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('👋', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '¡Hola, $name!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LettersCard extends StatelessWidget {
  const _LettersCard({required this.data});

  final _DashboardData data;

  @override
  Widget build(BuildContext context) {
    final pct = (data.lettersPercent * 100).round();
    return _DashCard(
      title: 'Letras dominadas',
      icon: '🔤',
      color: AppTheme.lettersColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.completedCount} de ${data.totalLetters} letras',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: data.lettersPercent,
              minHeight: 20,
              backgroundColor: AppTheme.lettersColor.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.lettersColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$pct% del abecedario',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textDark.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarsCard extends StatelessWidget {
  const _StarsCard({required this.data});

  final _DashboardData data;

  static const _levelNames = ['Ratón', 'Conejo', 'Gato', 'León'];
  static const _levelEmojis = ['🐭', '🐰', '🐱', '🦁'];

  @override
  Widget build(BuildContext context) {
    final stars = data.rewards?.totalStars ?? 0;
    final level = (data.rewards?.currentLevel ?? 1).clamp(1, 4);
    final levelName = _levelNames[level - 1];
    final levelEmoji = _levelEmojis[level - 1];
    return _DashCard(
      title: 'Estrellas y nivel',
      icon: '⭐',
      color: AppTheme.rewardsColor,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$stars ⭐',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total de estrellas',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textDark.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(levelEmoji, style: const TextStyle(fontSize: 36)),
              Text(
                'Nivel $level — $levelName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionsCard extends StatelessWidget {
  const _SessionsCard({required this.data});

  final _DashboardData data;

  String _formatDuration(Duration d) {
    if (d.inMinutes == 0) return 'menos de 1 min';
    if (d.inHours == 0) return '${d.inMinutes} min';
    return '${d.inHours}h ${d.inMinutes.remainder(60)}min';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return 'hoy';
    if (diff == 1) return 'ayer';
    return 'hace $diff días';
  }

  @override
  Widget build(BuildContext context) {
    final last = data.lastSession;
    final totalTime = data.totalSessionTime;
    return _DashCard(
      title: 'Sesiones de juego',
      icon: '🎮',
      color: AppTheme.gamesColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatItem(
                label: 'Sesiones totales',
                value: '${data.sessions.length}',
              ),
              const SizedBox(width: 24),
              _StatItem(
                label: 'Tiempo total',
                value: _formatDuration(totalTime),
              ),
            ],
          ),
          if (last != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Última sesión: ${_formatDate(last.startTime)} · ${_formatDuration(data.lastSessionDuration)}',
              style: const TextStyle(fontSize: 16, color: AppTheme.textDark),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Aún no hay sesiones registradas',
                style: TextStyle(fontSize: 16, color: AppTheme.textDark),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textDark.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.weeklyMinutes});

  final List<int> weeklyMinutes;

  @override
  Widget build(BuildContext context) {
    final maxMins = weeklyMinutes.fold(0, (a, b) => a > b ? a : b);
    final labels = ['hace 4s', 'hace 3s', 'hace 2s', 'sem pasada', 'esta sem'];

    return _DashCard(
      title: 'Progreso semanal',
      icon: '📈',
      color: AppTheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Minutos jugados por semana',
            style: TextStyle(fontSize: 14, color: AppTheme.textDark),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(5, (i) {
                final mins = weeklyMinutes[i];
                final ratio = maxMins > 0 ? mins / maxMins : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (mins > 0)
                          Text(
                            '$mins',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          height: 80 * ratio,
                          decoration: BoxDecoration(
                            color: i == 4
                                ? AppTheme.secondary
                                : AppTheme.secondary.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[i],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textDark,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onReset,
      icon: const Icon(Icons.refresh_rounded, color: Colors.red),
      label: const Text(
        'Reiniciar progreso de Leo',
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(64),
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  const _DashCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  final String title;
  final String icon;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
