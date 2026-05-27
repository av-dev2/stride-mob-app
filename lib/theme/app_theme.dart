import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stride Design System — Digital Architect aesthetic
/// Adapted from LinkSMS Stitch design. No-border rule, tonal layering.
class AppTheme {
  AppTheme._();

  // === Primary ===
  static const Color primary = Color(0xFF00236F);
  static const Color primaryContainer = Color(0xFF1E3A8A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF90A8FF);
  static const Color primaryFixed = Color(0xFFDCE1FF);
  static const Color primaryFixedDim = Color(0xFFB6C4FF);

  // === Secondary (Teal) ===
  static const Color secondary = Color(0xFF006A61);
  static const Color secondaryContainer = Color(0xFF86F2E4);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF006F66);

  // === Tertiary (Emerald) ===
  static const Color tertiary = Color(0xFF00311F);
  static const Color tertiaryContainer = Color(0xFF004A31);
  static const Color tertiaryFixed = Color(0xFF6FFBBE);
  static const Color tertiaryFixedDim = Color(0xFF4EDEA3);
  static const Color onTertiaryFixed = Color(0xFF002113);

  // === Error ===
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // === Surface hierarchy (tonal layering) ===
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceBright = Color(0xFFF9F9FF);
  static const Color surfaceDim = Color(0xFFD3DAEA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF0F3FF);
  static const Color surfaceContainer = Color(0xFFE7EEFE);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F8);
  static const Color surfaceContainerHighest = Color(0xFFDCE2F3);
  static const Color inverseSurface = Color(0xFF2A313D);
  static const Color inverseOnSurface = Color(0xFFEBF1FF);
  static const Color inversePrimary = Color(0xFFB6C4FF);

  // === On Surface ===
  static const Color onSurface = Color(0xFF151C27);
  static const Color onSurfaceVariant = Color(0xFF444651);
  static const Color outline = Color(0xFF757682);
  static const Color outlineVariant = Color(0xFFC5C5D3);
  static const Color surfaceTint = Color(0xFF4059AA);

  // === Status chip colors ===
  // Reconciled: secondaryContainer bg + onSecondaryContainer text
  // Unreconciled: errorContainer bg + onErrorContainer text  
  // Paid: tertiaryFixed bg + onTertiaryFixed text
  // Pending: surfaceContainerHighest bg + outline text
  // Postponed: inverseSurface bg + inverseOnSurface text

  /// Primary gradient for CTA buttons
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Card decoration — no border, tonal surface background
  static BoxDecoration tonalCardDecoration({
    Color color = surfaceContainerLowest,
    double radius = 12.0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Glassmorphism decoration for nav bar
  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      color: surfaceContainerLowest.withOpacity(0.85),
      border: Border(
        top: BorderSide(color: outlineVariant.withOpacity(0.2), width: 0.5),
      ),
    );
  }

  /// Ambient shadow for FAB and modals
  static List<BoxShadow> get ambientShadow {
    return [
      BoxShadow(
        color: primary.withOpacity(0.12),
        blurRadius: 24,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: primary.withOpacity(0.06),
        blurRadius: 48,
        offset: const Offset(0, 16),
        spreadRadius: 0,
      ),
    ];
  }

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: onPrimary,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        onSecondary: onSecondary,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        tertiaryContainer: tertiaryContainer,
        error: error,
        errorContainer: errorContainer,
        onError: onError,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: inverseSurface,
        inversePrimary: inversePrimary,
        surfaceTint: surfaceTint,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontSize: 32, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.5,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontSize: 28, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.5,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          fontSize: 24, fontWeight: FontWeight.w600, color: onSurface,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontSize: 22, fontWeight: FontWeight.w600, color: onSurface,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontSize: 20, fontWeight: FontWeight.w600, color: onSurface,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w600, color: onSurface,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w600, color: onSurface,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontSize: 16, fontWeight: FontWeight.w600, color: onSurface,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w600, color: onSurface,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w400, color: onSurface,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 13, fontWeight: FontWeight.w400, color: onSurfaceVariant,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontSize: 12, fontWeight: FontWeight.w400, color: onSurfaceVariant,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w500, color: onSurface,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant,
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          fontSize: 11, fontWeight: FontWeight.w500, color: outline,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20, fontWeight: FontWeight.w700, color: onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide.none,
          backgroundColor: surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: outlineVariant, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: outlineVariant, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceVariant),
        hintStyle: textTheme.bodyMedium?.copyWith(color: outline),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return secondary;
          return outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return secondaryContainer;
          return surfaceContainerHighest;
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: primary,
        unselectedItemColor: outline,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
    );
  }
}
