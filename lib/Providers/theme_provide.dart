import 'package:everdo_app/widget/App_text_styles.dart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme(bool value) async {
    if (_isDarkMode != value) {
      _isDarkMode = value;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);

      notifyListeners();
    }
  }

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme:const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      // ignore: deprecated_member_use
      background: AppColors.lightBackground,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.darkTextPrimary,
      centerTitle: true,
      elevation: 0,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColors.primary,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.darkTextPrimary,
    ),
  );
                            //dark theme of app //
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      // ignore: deprecated_member_use
      background: AppColors.darkBackground,
      surface: Colors.grey[850]!,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.darkTextPrimary,
      centerTitle: true,
      elevation: 0,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColors.primary,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.darkTextPrimary,
    ),
  );
}
