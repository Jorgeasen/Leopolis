import 'package:flutter_riverpod/flutter_riverpod.dart';

final storiesReadProvider =
    StateNotifierProvider<StoriesReadNotifier, Set<String>>(
  (_) => StoriesReadNotifier(),
);

class StoriesReadNotifier extends StateNotifier<Set<String>> {
  StoriesReadNotifier() : super({});

  void markRead(String storyId) {
    if (!state.contains(storyId)) {
      state = {...state, storyId};
    }
  }
}
