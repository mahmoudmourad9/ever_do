import 'package:flutter/material.dart';
import 'app_colors.dart';

class IceTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: IceColors.textIce,
      onPrimary: IceColors.surfaceIce,
      secondary: IceColors.accentIce,
      onSecondary: IceColors.surfaceIce,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: IceColors
          .surfaceIce, // Renamed from background for newer Flutter versions
      onSurface: IceColors.textIce,
      surfaceContainerHighest:
          IceColors.primaryIce, // A slight tint for containers
    ),
    scaffoldBackgroundColor: IceColors.backgroundIce,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: IceColors.textIce),
      titleTextStyle: TextStyle(
          color: IceColors.textIce,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlaypenSansArabic'),
    ),
    cardTheme: CardThemeData(
      color: IceColors.surfaceIce,
      elevation: 4,
      shadowColor: IceColors.accentIce.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: IceColors.accentIce,
      foregroundColor: IceColors.surfaceIce,
      elevation: 6,
    ),
    textTheme: const TextTheme(
      bodyLarge:
          TextStyle(color: IceColors.textIce, fontFamily: 'PlaypenSansArabic'),
      bodyMedium:
          TextStyle(color: IceColors.textIce, fontFamily: 'PlaypenSansArabic'),
      titleLarge: TextStyle(
          color: IceColors.textIce,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlaypenSansArabic'),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: IceColors.textNight,
      onPrimary: IceColors
          .backgroundNight, // Dark text on light primary in dark mode? Usually reverse. Let's stick to standard.
      secondary: IceColors.accentNight,
      onSecondary: IceColors.textNight,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: IceColors.surfaceNight,
      onSurface: IceColors.textNight,
      surfaceContainerHighest: IceColors.primaryNight,
    ),
    scaffoldBackgroundColor: IceColors.backgroundNight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: IceColors.textNight),
      titleTextStyle: TextStyle(
          color: IceColors.textNight,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlaypenSansArabic'),
    ),
    cardTheme: CardThemeData(
      color: IceColors.surfaceNight,
      elevation: 4,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: IceColors.accentNight,
      foregroundColor: IceColors.textNight,
      elevation: 6,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: IceColors.textNight, fontFamily: 'PlaypenSansArabic'),
      bodyMedium: TextStyle(
          color: IceColors.textNight, fontFamily: 'PlaypenSansArabic'),
      titleLarge: TextStyle(
          color: IceColors.textNight,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlaypenSansArabic'),
    ),
  );
}
