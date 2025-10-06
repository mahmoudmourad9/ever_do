import 'package:everdo_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const EverDoApp());

class EverDoApp extends StatefulWidget {
  const EverDoApp({super.key});

  @override
  State<EverDoApp> createState() => _EverDoAppState();
}

class _EverDoAppState extends State<EverDoApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: const Color(0xFF004A63),
        scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      home: SplashPage(onToggleTheme: toggleTheme),
    );
  }
}

