import 'package:flutter/material.dart';

/// Visual de ferramenta desktop ERP (neutro, sem estética “AI purple”).
class AppTheme {
  static const Color canvas = Color(0xFF1B2430);
  static const Color panel = Color(0xFF243041);
  static const Color panelAlt = Color(0xFF2C3A4F);
  static const Color border = Color(0xFF3D4F66);
  static const Color accent = Color(0xFF2F9E7B);
  static const Color accentMuted = Color(0xFF1F6F57);
  static const Color danger = Color(0xFFD96B6B);
  static const Color warning = Color(0xFFD4A017);
  static const Color text = Color(0xFFE8EEF6);
  static const Color textMuted = Color(0xFF9AABC0);

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Segoe UI',
      colorScheme: const ColorScheme.dark(
        surface: panel,
        primary: accent,
        onPrimary: Colors.white,
        secondary: accentMuted,
        error: danger,
        onSurface: text,
      ),
      scaffoldBackgroundColor: canvas,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: panel,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
      ),
      dividerColor: border,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: canvas,
        hintStyle: const TextStyle(color: textMuted),
        labelStyle: const TextStyle(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accent, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      dataTableTheme: const DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(panelAlt),
        dataRowMinHeight: 36,
        dataRowMaxHeight: 44,
        headingTextStyle: TextStyle(
          color: text,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        dataTextStyle: TextStyle(color: text, fontSize: 13),
      ),
    );
  }
}
