import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color violet = Color(0xFF6C3BFF);
  static const Color lightViolet = Color(0xFFEEE8FF);
  static const Color cardWhite = Color(0xFFFDFDFF);
  static const Color textDark = Color(0xFF251C45);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: violet,
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
    );

    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: textDark,
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: violet.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: violet.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: violet.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: violet, width: 1.5),
        ),
      ),
    );
  }
}
