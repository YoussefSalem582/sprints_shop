import 'package:flutter/material.dart';

/// A reusable app logo widget that displays the app's logo image
/// Uses the existing app_logo.jpg file as the primary logo
class AppLogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final Color? textColor;
  final double? textSize;
  final bool isHeroLogo;

  const AppLogoWidget({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.textColor,
    this.textSize,
    this.isHeroLogo = false,
  });

  /// Small logo for app bars and compact spaces
  const AppLogoWidget.small({
    super.key,
    this.showText = false,
    this.textColor,
    this.textSize,
    this.isHeroLogo = false,
  }) : width = 40,
       height = 40;

  /// Medium logo for regular use
  const AppLogoWidget.medium({
    super.key,
    this.showText = true,
    this.textColor,
    this.textSize,
    this.isHeroLogo = false,
  }) : width = 100,
       height = 100;

  /// Large logo for splash screens and welcome pages
  const AppLogoWidget.large({
    super.key,
    this.showText = true,
    this.textColor,
    this.textSize = 32,
    this.isHeroLogo = true,
  }) : width = 150,
       height = 150;

  @override
  Widget build(BuildContext context) {
    Widget logoImage = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isHeroLogo
            ? [
                BoxShadow(
                  color: const Color(0xFF4C8FC3).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/app_logo/app_logo.jpg',
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback logo if image fails to load
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4C8FC3),
                    const Color(0xFF4C8FC3).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: (width ?? 80) * 0.5,
              ),
            );
          },
        ),
      ),
    );

    if (!showText) {
      return logoImage;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoImage,
        const SizedBox(height: 12),
        Text(
          'Sprints Shop',
          style: TextStyle(
            fontSize: textSize ?? 24,
            fontWeight: FontWeight.bold,
            color: textColor ?? const Color(0xFF4C8FC3),
            letterSpacing: 1.2,
          ),
        ),
        if (isHeroLogo) ...[
          const SizedBox(height: 4),
          Text(
            'Your Shopping Destination',
            style: TextStyle(
              fontSize: (textSize ?? 24) * 0.5,
              color: (textColor ?? const Color(0xFF4C8FC3)).withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
