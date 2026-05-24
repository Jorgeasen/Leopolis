import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Paleta de colores Leópolis — vivos y amigables para niños
  static const Color primary = Color(0xFFFF8C00); // Naranja León
  static const Color secondary = Color(0xFF4CAF50); // Verde prado
  static const Color accent = Color(0xFFFFEB3B); // Amarillo sol
  static const Color background = Color(0xFFFFF8E1); // Crema suave
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color textDark = Color(0xFF3E2723); // Marrón cálido
  static const Color textLight = Color(0xFFFFFFFF);

  // Colores por módulo
  static const Color lettersColor = Color(0xFF2196F3); // Azul
  static const Color wordsColor = Color(0xFF9C27B0); // Morado
  static const Color gamesColor = Color(0xFFFF5722); // Rojo-naranja
  static const Color rewardsColor = Color(0xFFFFD700); // Dorado

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.fredokaTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayMedium: GoogleFonts.fredoka(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineLarge: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.fredoka(
          fontSize: 20,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.fredoka(
          fontSize: 16,
          color: textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textLight,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.fredoka(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          elevation: 4,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: surface,
      ),
    );
  }
}
