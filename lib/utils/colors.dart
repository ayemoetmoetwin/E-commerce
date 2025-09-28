import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Colors.black;
  static const Color primaryLight = Color(0xFFE7E7E7);
  static const Color primaryDark = Color(0xFF000000);

  // Secondary Colors
  static const Color secondary = Colors.white;
  static const Color secondaryLight = Color(0xFFF5F5F5);
  static const Color secondaryDark = Color(0xFFE0E0E0);

  // Background Colors
  static const Color background = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.black;
  static const Color textGreen = Color(0xFF00A72A);

  // Accent Colors
  static const Color accent = Color(0xFF007AFF);
  static const Color accentLight = Color(0xFF4DA6FF);
  static const Color accentDark = Color(0xFF0056CC);

  // Status Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF333333);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF333333);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  static const Color transparent = Color(0x00000000);

  // Card Colors
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundDark = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color cardBorderDark = Color(0xFF333333);

  // Button Colors
  static const Color buttonPrimary = Colors.black;
  static const Color buttonSecondary = Colors.white;
  static const Color buttonDisabled = Color(0xFFCCCCCC);
  static const Color buttonText = Colors.white;
  static const Color buttonTextSecondary = Colors.black;

  // Icon Colors
  static const Color iconPrimary = Colors.black;
  static const Color iconSecondary = Color(0xFF666666);
  static const Color iconOnPrimary = Colors.white;
  static const Color iconOnSecondary = Colors.black;
  static const Color iconGrey = Color(0xFF616161);
  static const Color iconGreyLight = Color(0xFFEEEEEE);
  static const Color grey_500 = Color(0xFF9E9E9E);

  // Rating Colors
  static const Color rating = Color(0xFFFFD700);
  static const Color ratingEmpty = Color(0xFFE0E0E0);

  // Favorite Colors
  static const Color favorite = Color(0xFFFF3B30);
  static const Color favoritelight = Color(0xFFBF342D);
  static const Color favoriteDark = Color(0xFFFF3B30);
  static const Color favoriteEmpty = Color(0xFFCCCCCC);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.black, Color(0xFF333333)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFF5F5F5)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
  );

  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}
