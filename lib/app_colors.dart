import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand primary – RGB(36, 84, 206)
  static const Color primary = Color(0xFF2454CE);
  static const Color primaryDark = Color(0xFF1A3AA3);
  static const Color primaryContainer = Color(0xFFDDE4FF);
  static const Color softAccent = Color(0xFF8FA8F0);

  // Neutral
  static const Color background = Color(0xFFF5F7FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFEEF1FA);
  static const Color border = Color(0xFFDDE2F2);

  // Typography
  static const Color textPrimary = Color(0xFF0D1B4B);
  static const Color textSecondary = Color(0xFF5A6A9A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
}

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  final Color primary;
  final Color primaryDark;
  final Color primaryContainer;
  final Color background;
  final Color surface;
  final Color surfaceSoft;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textOnPrimary;
  final Color error;
  final Color success;
  final Color warning;

  const AppColorTheme({
    required this.primary,
    required this.primaryDark,
    required this.primaryContainer,
    required this.background,
    required this.surface,
    required this.surfaceSoft,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnPrimary,
    required this.error,
    required this.success,
    required this.warning,
  });

  static AppColorTheme get light => const AppColorTheme(
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    primaryContainer: AppColors.primaryContainer,
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceSoft: AppColors.surfaceSoft,
    border: AppColors.border,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textOnPrimary: AppColors.textOnPrimary,
    error: AppColors.error,
    success: AppColors.success,
    warning: AppColors.warning,
  );

  @override
  AppColorTheme copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryContainer,
    Color? background,
    Color? surface,
    Color? surfaceSoft,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textOnPrimary,
    Color? error,
    Color? success,
    Color? warning,
  }) {
    return AppColorTheme(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColorTheme lerp(covariant AppColorTheme? other, double t) {
    if (other == null) return this;
    return AppColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

extension AppColorThemeExtension on BuildContext {
  AppColorTheme get colors => Theme.of(this).extension<AppColorTheme>()!;
}
