import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:everdo_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const EverDoApp(),
    ),
  );
}

class EverDoApp extends StatelessWidget {
  const EverDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EverDo App',
          theme: themeProvider.themeData,
          home: SplashPage(onThemeChanged: themeProvider.toggleTheme),
        );
      },
    );
  }
}
