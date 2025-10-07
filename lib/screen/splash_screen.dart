import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_navigation_screen.dart'; 

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
              Text(
                'Write Down',
                style: GoogleFonts.pacifico(fontSize: 28),
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Transform.rotate(
                  //   angle: 0.01,
                  //   child: Container(
                  //     height: 46,
                  //     width: 270,
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade300,
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  // ),
                  Text(
                    "What's In Your Mind",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004A63),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18,)
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                 
                          builder: (_) =>
                              MainNavigationScreen(onToggleTheme: onToggleTheme),
                        ));
                  },
                  child: const Text('Get Started'))
            ],
          ),
        ),
      ),
    );
  }
}
