import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'diary_screen.dart';

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

class SplashPage extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const SplashPage({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DiaryScreen(onToggleTheme: onToggleTheme),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 320,
                  height: 320,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 60),
                Text(
                  'Write Down',
                  style: GoogleFonts.pacifico(fontSize: 28),
                ),
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 0.01,
                      child: Container(
                        height: 46,
                        width: 270,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Text(
                      "What's In Your Mind",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
