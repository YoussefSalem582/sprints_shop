import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/localization_provider.dart';
import 'app_logo_widget.dart';
import '../l10n/app_localizations_static.dart';

class LocalizedText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const LocalizedText(
    this.textKey, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        final text = AppLocalizations.translate(
          textKey,
          localizationProvider.currentLocale.languageCode,
        );

        return Text(
          text,
          style: style,
          textAlign: textAlign ?? localizationProvider.startTextAlign,
          overflow: overflow,
          maxLines: maxLines,
          textDirection: localizationProvider.textDirection,
        );
      },
    );
  }
}

class RTLWidget extends StatelessWidget {
  final Widget child;

  const RTLWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, _) {
        return Directionality(
          textDirection: localizationProvider.textDirection,
          child: child,
        );
      },
    );
  }
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        return PopupMenuButton<Locale>(
          onSelected: (locale) => localizationProvider.changeLocale(locale),
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language),
              const SizedBox(width: 4),
              Text(
                localizationProvider.isArabic ? 'عربي' : 'EN',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: const Locale('en'),
              child: Row(
                children: [
                  const Icon(Icons.flag, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.translate('english', 'en')),
                  if (localizationProvider.isEnglish)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, color: Colors.green),
                    ),
                ],
              ),
            ),
            PopupMenuItem(
              value: const Locale('ar'),
              child: Row(
                children: [
                  const Icon(Icons.flag, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.translate('arabic', 'ar')),
                  if (localizationProvider.isArabic)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, color: Colors.green),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class LocalizedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;

  const LocalizedAppBar({
    super.key,
    required this.titleKey,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        return AppBar(
          title: LocalizedText(
            titleKey,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [if (actions != null) ...actions!, const LanguageSelector()],
          leading: leading,
          backgroundColor: backgroundColor,
          elevation: elevation,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar with logo and localization support
class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleKey;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;
  final bool showLogo;

  const LogoAppBar({
    super.key,
    this.titleKey,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        Widget title;
        if (showLogo) {
          title = const AppLogoWidget.small(showText: true, textSize: 16);
        } else if (titleKey != null) {
          title = LocalizedText(
            titleKey!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        } else {
          title = const SizedBox.shrink();
        }

        return AppBar(
          title: title,
          actions: [if (actions != null) ...actions!, const LanguageSelector()],
          leading: leading,
          backgroundColor: backgroundColor,
          elevation: elevation,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CurrencyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;

  const CurrencyText({super.key, required this.amount, this.style});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        return Text(
          localizationProvider.formatCurrency(amount),
          style: style,
          textDirection: localizationProvider.textDirection,
        );
      },
    );
  }
}

class LocalizedButton extends StatelessWidget {
  final String textKey;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;

  const LocalizedButton({
    super.key,
    required this.textKey,
    this.onPressed,
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        final text = AppLocalizations.translate(
          textKey,
          localizationProvider.currentLocale.languageCode,
        );

        if (icon != null) {
          return ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: Text(text),
            style: style,
          );
        } else {
          return ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: Text(text),
          );
        }
      },
    );
  }
}
