class AppConstants {
  AppConstants._();

  // App
  static const String appName = 'Leópolis';
  static const String appVersion = '1.0.0';

  // Rutas
  static const String routeHome = '/';
  static const String routeLetters = '/letters';
  static const String routeWords = '/words';
  static const String routeGames = '/games';
  static const String routeRewards = '/rewards';
  static const String routeSettings = '/settings';

  // Assets
  static const String assetsImages = 'assets/images/';
  static const String assetsAudio = 'assets/audio/';
  static const String assetsAnimations = 'assets/animations/';

  // Shared Preferences keys
  static const String prefCurrentLevel = 'current_level';
  static const String prefTotalStars = 'total_stars';
  static const String prefLettersCompleted = 'letters_completed';
  static const String prefWordsCompleted = 'words_completed';
  static const String prefSoundEnabled = 'sound_enabled';
  static const String prefVoiceEnabled = 'voice_enabled';

  // Gamificación
  static const int starsPerExercise = 3;
  static const int starsToUnlockLevel = 9;

  // Letras del abecedario español
  static const List<String> spanishAlphabet = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'Ñ', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ];
}
