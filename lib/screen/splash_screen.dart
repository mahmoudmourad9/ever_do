import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class SplashPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SplashPage({super.key, required this.onThemeChanged});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoSPL.png',
                width: 210,
                height: 210,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),

         
              const Text(
                'Write Down',
                style: TextStyle(
                  fontFamily: 'Pacifico', 
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "What's In Your Mind",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'jomhuria', 
                  fontSize: 42,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
