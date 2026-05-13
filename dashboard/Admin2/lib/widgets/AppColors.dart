import 'package:flutter/material.dart';

class AppColors {

  // ================= PRIMARY =================
  static const Color primary =
  Color(0xFF5A0891);

  static const Color secondary =
  Color(0xFFD59EFA);

  // ================= BACKGROUND =================
  static const Color background =
  Color(0xFFF8F3FF);

  static const Color darkBackground =
  Color(0xFF12061D);

  // ================= SURFACE =================
  static const Color card =
  Color(0xFFFFFFFF);

  static const Color darkCard =
  Color(0xFF1E102A);

  // ================= TEXT =================
  static const Color white = Colors.white;

  static const Color grey =
  Color(0xFF777777);

  static const Color darkText =
  Color(0xFF2A0E3F);

  // ================= STATUS =================
  static const Color success =
  Color(0xFF00C896);

  static const Color danger =
  Color(0xFFFF4D6D);

  // ================= GRADIENTS =================
  static const LinearGradient primaryGradient =
  LinearGradient(
    colors: [
      Color(0xFF5A0891),
      Color(0xFF7B1FA2),
      Color(0xFFD59EFA),
    ],

    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient =
  LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8F3FF),
    ],

    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}