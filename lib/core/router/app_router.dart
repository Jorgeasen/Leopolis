import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/letters/presentation/letter_detail_screen.dart';
import '../../features/letters/presentation/letter_tracing_screen.dart';
import '../../features/letters/presentation/letters_screen.dart';
import '../../features/words/presentation/first_letter_screen.dart';
import '../../features/words/presentation/rhyme_check_screen.dart';
import '../../features/words/presentation/syllable_build_screen.dart';
import '../../features/words/presentation/syllable_count_screen.dart';
import '../../features/words/presentation/syllable_dictation_screen.dart';
import '../../features/words/presentation/syllable_screen.dart';
import '../../features/words/presentation/word_match_screen.dart';
import '../../features/words/presentation/words_screen.dart';
import '../../features/games/presentation/falling_letters_game.dart';
import '../../features/games/presentation/games_screen.dart';
import '../../features/games/presentation/memory_game.dart';
import '../../features/games/presentation/missing_letter_game.dart';
import '../../features/games/presentation/word_scramble_game.dart';
import '../../features/stories/presentation/stories_screen.dart';
import '../../features/stories/presentation/story_reader_screen.dart';
import '../../features/auth/presentation/parent_dashboard_screen.dart';
import '../../features/auth/presentation/parent_login_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import '../../features/settings/data/settings_provider.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../constants/app_constants.dart';

part 'app_router.g.dart';

Page<void> _fadeSlidePage(Widget child, GoRouterState state) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );

@riverpod
GoRouter appRouter(Ref ref) {
  final settingsAsync = ref.watch(settingsProvider);

  return GoRouter(
    initialLocation: AppConstants.routeHome,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final settings = settingsAsync.valueOrNull;
      if (settings == null) return null;
      final onWelcome = state.matchedLocation == '/welcome';
      if (!settings.hasCompletedOnboarding && !onWelcome) return '/welcome';
      if (settings.hasCompletedOnboarding && onWelcome) {
        return AppConstants.routeHome;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        pageBuilder: (c, s) => _fadeSlidePage(const WelcomeScreen(), s),
      ),
      GoRoute(
        path: AppConstants.routeHome,
        pageBuilder: (c, s) => _fadeSlidePage(const HomeScreen(), s),
      ),
      GoRoute(
        path: AppConstants.routeLetters,
        pageBuilder: (c, s) => _fadeSlidePage(const LettersScreen(), s),
      ),
      GoRoute(
        path: '/letters/:letter',
        pageBuilder: (c, s) {
          final letter = s.pathParameters['letter'] ?? 'A';
          return _fadeSlidePage(LetterDetailScreen(letter: letter), s);
        },
      ),
      GoRoute(
        path: '/letters/:letter/tracing',
        pageBuilder: (c, s) {
          final letter = s.pathParameters['letter'] ?? 'A';
          return _fadeSlidePage(LetterTracingScreen(letter: letter), s);
        },
      ),
      GoRoute(
        path: AppConstants.routeWords,
        pageBuilder: (c, s) => _fadeSlidePage(const WordsScreen(), s),
      ),
      GoRoute(
        path: '/words/match',
        pageBuilder: (c, s) => _fadeSlidePage(const WordMatchScreen(), s),
      ),
      GoRoute(
        path: '/words/syllable',
        pageBuilder: (c, s) => _fadeSlidePage(const SyllableScreen(), s),
      ),
      GoRoute(
        path: '/words/syllable-dictation',
        pageBuilder: (c, s) =>
            _fadeSlidePage(const SyllableDictationScreen(), s),
      ),
      GoRoute(
        path: '/words/first-letter',
        pageBuilder: (c, s) => _fadeSlidePage(const FirstLetterScreen(), s),
      ),
      GoRoute(
        path: '/words/syllable-count',
        pageBuilder: (c, s) => _fadeSlidePage(const SyllableCountScreen(), s),
      ),
      GoRoute(
        path: '/words/rhyme-check',
        pageBuilder: (c, s) => _fadeSlidePage(const RhymeCheckScreen(), s),
      ),
      GoRoute(
        path: '/words/syllable-build',
        pageBuilder: (c, s) => _fadeSlidePage(const SyllableBuildScreen(), s),
      ),
      GoRoute(
        path: AppConstants.routeGames,
        pageBuilder: (c, s) => _fadeSlidePage(const GamesScreen(), s),
      ),
      GoRoute(
        path: '/games/memory',
        pageBuilder: (c, s) => _fadeSlidePage(const MemoryGame(), s),
      ),
      GoRoute(
        path: '/games/falling-letters',
        pageBuilder: (c, s) => _fadeSlidePage(const FallingLettersGame(), s),
      ),
      GoRoute(
        path: '/games/missing-letter',
        pageBuilder: (c, s) => _fadeSlidePage(const MissingLetterGame(), s),
      ),
      GoRoute(
        path: '/games/word-scramble',
        pageBuilder: (c, s) =>
            _fadeSlidePage(WordScrambleGame(key: UniqueKey()), s),
      ),
      GoRoute(
        path: AppConstants.routeStories,
        pageBuilder: (c, s) => _fadeSlidePage(const StoriesScreen(), s),
      ),
      GoRoute(
        path: '/stories/:id',
        pageBuilder: (c, s) {
          final id = s.pathParameters['id'] ?? '';
          return _fadeSlidePage(StoryReaderScreen(storyId: id), s);
        },
      ),
      GoRoute(
        path: AppConstants.routeRewards,
        pageBuilder: (c, s) => _fadeSlidePage(const RewardsScreen(), s),
      ),
      GoRoute(
        path: AppConstants.routeSettings,
        pageBuilder: (c, s) => _fadeSlidePage(const SettingsScreen(), s),
      ),
      GoRoute(
        path: '/parent-login',
        pageBuilder: (c, s) => _fadeSlidePage(const ParentLoginScreen(), s),
      ),
      GoRoute(
        path: '/parent-dashboard',
        pageBuilder: (c, s) => _fadeSlidePage(const ParentDashboardScreen(), s),
      ),
    ],
  );
}
