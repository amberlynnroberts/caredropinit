import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color _primary = const Color(0xFF1C415E);
final Color _secondary = const Color(0xFFF7BE46);

ThemeData caredropTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primary,
    primary: _primary,
    secondary: _secondary,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.interTextTheme(),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(120, 48),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);

