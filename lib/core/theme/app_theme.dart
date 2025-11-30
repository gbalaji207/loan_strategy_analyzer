import 'package:flutter/material.dart';

/// Design system for the Loan Strategy Analyzer
/// Centralizes colors, typography, spacing, and theme configuration
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================================================
  // COLOR PALETTE
  // ============================================================================

  // Primary Colors - Professional blue palette
  static const Color primaryBlue = Color(0xFF2563EB); // Modern blue
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1E40AF);
  static const Color primaryBlueSubtle = Color(0xFFEFF6FF);

  // Accent Colors
  static const Color accentGreen = Color(0xFF10B981); // Success/positive
  static const Color accentGreenLight = Color(0xFFD1FAE5);
  static const Color accentOrange = Color(0xFFF59E0B); // Warning/attention
  static const Color accentOrangeLight = Color(0xFFFEF3C7);
  static const Color accentRed = Color(0xFFEF4444); // Error/negative
  static const Color accentRedLight = Color(0xFFFEE2E2);

  // Neutral Colors - Rich grays
  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral50 = Color(0xFFF9FAFB);

  // Background Colors
  static const Color backgroundPrimary = Colors.white;
  static const Color backgroundSecondary = neutral50;
  static const Color backgroundTertiary = neutral100;

  // ============================================================================
  // TYPOGRAPHY
  // ============================================================================

  static const String fontFamily =
      'Inter'; // You can use default or add custom font

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: neutral900,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.3,
    color: neutral900,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.2,
    color: neutral900,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: neutral900,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: neutral700,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: neutral700,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: neutral600,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: neutral900,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: neutral700,
  );

  // ============================================================================
  // SPACING
  // ============================================================================

  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  static const double radiusSmall = 6.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  static const BorderRadius borderRadiusSmall = BorderRadius.all(
    Radius.circular(radiusSmall),
  );
  static const BorderRadius borderRadiusMedium = BorderRadius.all(
    Radius.circular(radiusMedium),
  );
  static const BorderRadius borderRadiusLarge = BorderRadius.all(
    Radius.circular(radiusLarge),
  );
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(
    Radius.circular(radiusXLarge),
  );

  // ============================================================================
  // SHADOWS
  // ============================================================================

  static List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: neutral900.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: neutral900.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: neutral900.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // ============================================================================
  // MATERIAL THEME
  // ============================================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentGreen,
        surface: backgroundPrimary,
        error: accentRed,
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        displaySmall: heading3,
        headlineMedium: heading4,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLarge,
          side: BorderSide(color: neutral200, width: 1),
        ),
        color: backgroundPrimary,
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusMedium),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neutral700,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: neutral300, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusMedium),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: BorderSide(color: neutral300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: BorderSide(color: neutral300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: accentRed, width: 1.5),
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: neutral600,
        ),
        hintStyle: TextStyle(fontSize: 14, color: neutral400),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(color: neutral200, thickness: 1, space: 1),

      // Icon Theme
      iconTheme: IconThemeData(color: neutral600, size: 20),
    );
  }
}
