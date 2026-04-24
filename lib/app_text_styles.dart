import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700);

  static TextStyle get headlineLarge => GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700);

  static TextStyle get headlineMedium => GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700);

  static TextStyle get titleLarge => GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get titleMedium => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get titleSmall => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get bodySmall => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle get labelLarge => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get labelSmall => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600);

  static TextTheme get light => TextTheme(
    displayLarge: displayLarge.copyWith(color: const Color(0xFF0D1B4B)),
    headlineLarge: headlineLarge.copyWith(color: const Color(0xFF0D1B4B)),
    headlineMedium: headlineMedium.copyWith(color: const Color(0xFF0D1B4B)),
    titleLarge: titleLarge.copyWith(color: const Color(0xFF0D1B4B)),
    titleMedium: titleMedium.copyWith(color: const Color(0xFF0D1B4B)),
    titleSmall: titleSmall.copyWith(color: const Color(0xFF5A6A9A)),
    bodyLarge: bodyLarge.copyWith(color: const Color(0xFF0D1B4B)),
    bodyMedium: bodyMedium.copyWith(color: const Color(0xFF0D1B4B)),
    bodySmall: bodySmall.copyWith(color: const Color(0xFF5A6A9A)),
    labelLarge: labelLarge.copyWith(color: const Color(0xFF0D1B4B)),
    labelSmall: labelSmall.copyWith(color: const Color(0xFF5A6A9A)),
  );
}
