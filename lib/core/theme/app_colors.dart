import 'package:flutter/material.dart';

class IceColors {
  // Day Ice (Light Mode)
  static const Color primaryIce = Color(0xFFB3E5FC); // Light Blue 100
  static const Color accentIce = Color(0xFF4FC3F7); // Light Blue 300
  static const Color backgroundIce = Color(0xFFF0F8FF); // Alice Blue
  static const Color surfaceIce = Color(0xFFFFFFFF); // White
  static const Color textIce =
      Color(0xFF0D47A1); // Dark Blue 900 (High contrast)

  // Night Ice (Dark Mode)
  static const Color primaryNight = Color(0xFF0277BD); // Light Blue 800
  static const Color accentNight = Color(0xFF01579B); // Light Blue 900
  static const Color backgroundNight = Color(0xFF102027); // Dark Blue Grey
  static const Color surfaceNight = Color(0xFF263238); // Blue Grey 900
  static const Color textNight = Color(0xFFE1F5FE); // Light Blue 50

  // Gradients
  static const LinearGradient iceGradient = LinearGradient(
    colors: [primaryIce, accentIce],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nightGradient = LinearGradient(
    colors: [backgroundNight, Color(0xFF000A12)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
