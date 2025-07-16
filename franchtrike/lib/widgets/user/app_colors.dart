import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryNavy = Color(0xFF1D2761);
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color accentPurple = Color(0xFF5E2D79);
  static const Color accentRed = Color(0xFFE63946);
  static const Color accentGreen = Color(0xFF2A9D8F);
  static const Color white = Color(0xFFFFFFFF);

  // Aliases and additional colors for UI consistency
  static const Color primary = primaryNavy;
  static const Color secondary = accentPurple;
  static const Color error = accentRed;
  static const Color errorLight = Color(0xFFFFE5E9); // light red
  static const Color success = accentGreen;
  static const Color successLight = Color(0xFFD1F2EB); // light green
  static const Color warning = primaryGold;
  static const Color danger = accentRed;
  static const Color gray = Color(0xFFB0B0B0);
  static const Color textPrimary = primaryNavy;
  static const Color textSecondary = gray;
  static const Color border = Color(0xFFE0E0E0);

  // Material colors for compatibility
  static const Color blue = Colors.blue;
  static const Color blueAccent = Colors.blueAccent;
  static const Color amber = Colors.amber;
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color redAccent = Colors.redAccent;
  static const Color black12 = Colors.black12;
  static const Color grey = Colors.grey;
} 