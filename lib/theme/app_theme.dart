import 'package:flutter/material.dart';

/// Modern design system with enhanced colors, typography, and components
class AppDesignSystem {
  // Enhanced Color Palette
  static const Color primaryBlue = Color(0xFF4C8FC3);
  static const Color primaryBlueDark = Color(0xFF3A6B94);
  static const Color primaryBlueLight = Color(0xFF7AB5D6);

  static const Color secondaryOrange = Color(0xFFFF8A65);
  static const Color secondaryOrangeLight = Color(0xFFFFB74D);

  static const Color accentGreen = Color(0xFF66BB6A);
  static const Color accentRed = Color(0xFFEF5350);

  // Neutral Colors
  static const Color backgroundLight = Color(0xFFFAFCFF);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F7FA);

  static const Color textPrimary = Color(0xFF1A1D29);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFCFF), Color(0xFFF0F4F8)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFFAFCFF)],
  );

  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow elevatedShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  // Border Radius
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(
    Radius.circular(12),
  );
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXLarge = BorderRadius.all(
    Radius.circular(24),
  );

  // Spacing
  static const double spaceXS = 4;
  static const double spaceSM = 8;
  static const double spaceMD = 16;
  static const double spaceLG = 24;
  static const double spaceXL = 32;
  static const double spaceXXL = 48;

  // Typography
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textMuted,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );
}

/// Enhanced Material 3 theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppDesignSystem.primaryBlue,
        brightness: Brightness.light,
        primary: AppDesignSystem.primaryBlue,
        secondary: AppDesignSystem.secondaryOrange,
        background: AppDesignSystem.backgroundLight,
        surface: AppDesignSystem.backgroundCard,
        error: AppDesignSystem.accentRed,
      ),
      scaffoldBackgroundColor: AppDesignSystem.backgroundLight,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppDesignSystem.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppDesignSystem.backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.radiusMedium,
          side: const BorderSide(color: AppDesignSystem.borderLight, width: 1),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesignSystem.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppDesignSystem.radiusMedium,
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDesignSystem.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: AppDesignSystem.radiusMedium,
          borderSide: const BorderSide(color: AppDesignSystem.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDesignSystem.radiusMedium,
          borderSide: const BorderSide(color: AppDesignSystem.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDesignSystem.radiusMedium,
          borderSide: const BorderSide(
            color: AppDesignSystem.primaryBlue,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: AppDesignSystem.headingLarge,
        headlineMedium: AppDesignSystem.headingMedium,
        headlineSmall: AppDesignSystem.headingSmall,
        bodyLarge: AppDesignSystem.bodyLarge,
        bodyMedium: AppDesignSystem.bodyMedium,
        bodySmall: AppDesignSystem.bodySmall,
        labelLarge: AppDesignSystem.labelLarge,
        labelMedium: AppDesignSystem.labelMedium,
      ),
    );
  }
}

/// Modern UI component widgets
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool elevated;
  final bool gradient;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevated = false,
    this.gradient = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardChild = Container(
      decoration: BoxDecoration(
        gradient: gradient ? AppDesignSystem.cardGradient : null,
        color: gradient ? null : AppDesignSystem.backgroundCard,
        borderRadius: AppDesignSystem.radiusMedium,
        border: Border.all(color: AppDesignSystem.borderLight, width: 1),
        boxShadow: elevated
            ? [AppDesignSystem.elevatedShadow]
            : [AppDesignSystem.cardShadow],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDesignSystem.spaceMD),
        child: child,
      ),
    );

    if (onTap != null) {
      cardChild = InkWell(
        onTap: onTap,
        borderRadius: AppDesignSystem.radiusMedium,
        child: cardChild,
      );
    }

    return Container(margin: margin, child: cardChild);
  }
}

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool isOutlined;
  final IconData? icon;
  final bool loading;
  final double? width;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
    this.isOutlined = false,
    this.icon,
    this.loading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSecondary
        ? AppDesignSystem.secondaryOrange
        : AppDesignSystem.primaryBlue;

    Color foregroundColor = Colors.white;

    if (isOutlined) {
      backgroundColor = Colors.transparent;
      foregroundColor = AppDesignSystem.primaryBlue;
    }

    Widget buttonChild = loading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppDesignSystem.spaceSM),
              ],
              Text(text),
            ],
          );

    return Container(
      width: width,
      height: 48,
      decoration: BoxDecoration(
        gradient: !isOutlined && !loading
            ? AppDesignSystem.primaryGradient
            : null,
        color: isOutlined
            ? null
            : (loading ? backgroundColor.withOpacity(0.7) : null),
        borderRadius: AppDesignSystem.radiusMedium,
        border: isOutlined
            ? Border.all(color: AppDesignSystem.primaryBlue, width: 2)
            : null,
        boxShadow: !isOutlined && !loading
            ? [AppDesignSystem.cardShadow]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: AppDesignSystem.radiusMedium,
          child: Center(child: buttonChild),
        ),
      ),
    );
  }
}

class ModernChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  const ModernChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppDesignSystem.primaryBlue;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDesignSystem.radiusLarge,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceMD,
          vertical: AppDesignSystem.spaceSM,
        ),
        decoration: BoxDecoration(
          color: selected ? effectiveColor : effectiveColor.withOpacity(0.1),
          borderRadius: AppDesignSystem.radiusLarge,
          border: Border.all(
            color: selected ? effectiveColor : AppDesignSystem.borderMedium,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : effectiveColor,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
