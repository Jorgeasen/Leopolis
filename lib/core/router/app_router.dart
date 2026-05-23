import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/letters/presentation/letters_screen.dart';
import '../../features/words/presentation/words_screen.dart';
import '../../features/games/presentation/games_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import '../constants/app_constants.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppConstants.routeHome,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppConstants.routeHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.routeLetters,
        builder: (context, state) => const LettersScreen(),
      ),
      GoRoute(
        path: AppConstants.routeWords,
        builder: (context, state) => const WordsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeGames,
        builder: (context, state) => const GamesScreen(),
      ),
      GoRoute(
        path: AppConstants.routeRewards,
        builder: (context, state) => const RewardsScreen(),
      ),
    ],
  );
}
