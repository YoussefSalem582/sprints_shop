import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  static const String _localeKey = 'selected_locale';

  Locale get currentLocale => _currentLocale;
  bool get isRTL => _currentLocale.languageCode == 'ar';
  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ar', ''), // Arabic
  ];

  // Load saved locale
  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);

      if (localeCode != null) {
        _currentLocale = Locale(localeCode);
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error loading locale: $error');
      }
    }
  }

  // Save locale
  Future<void> _saveLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, _currentLocale.languageCode);
    } catch (error) {
      if (kDebugMode) {
        print('Error saving locale: $error');
      }
    }
  }

  // Change locale
  Future<void> changeLocale(Locale newLocale) async {
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      notifyListeners();
      await _saveLocale();
    }
  }

  // Toggle between English and Arabic
  Future<void> toggleLanguage() async {
    final newLocale = _currentLocale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    await changeLocale(newLocale);
  }

  // Get currency symbol based on locale
  String get currencySymbol {
    switch (_currentLocale.languageCode) {
      case 'ar':
        return 'ر.س'; // Saudi Riyal
      default:
        return '\$'; // US Dollar
    }
  }

  // Format currency
  String formatCurrency(double amount) {
    final formattedAmount = amount.toStringAsFixed(2);

    if (isArabic) {
      return '$formattedAmount $currencySymbol';
    } else {
      return '$currencySymbol$formattedAmount';
    }
  }

  // Format date based on locale
  String formatDate(DateTime date) {
    if (isArabic) {
      // Arabic date format: day/month/year
      return '${date.day}/${date.month}/${date.year}';
    } else {
      // English date format: month/day/year
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  // Format time based on locale
  String formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');

    if (isArabic) {
      // 24-hour format for Arabic
      return '$hour:$minute';
    } else {
      // 12-hour format for English
      final displayHour = hour == 0
          ? 12
          : hour > 12
          ? hour - 12
          : hour;
      final period = hour >= 12 ? 'PM' : 'AM';
      return '$displayHour:$minute $period';
    }
  }

  // Get text direction
  TextDirection get textDirection {
    return isRTL ? TextDirection.rtl : TextDirection.ltr;
  }

  // Get alignment based on locale
  Alignment get startAlignment {
    return isRTL ? Alignment.centerRight : Alignment.centerLeft;
  }

  Alignment get endAlignment {
    return isRTL ? Alignment.centerLeft : Alignment.centerRight;
  }

  // Get text align based on locale
  TextAlign get startTextAlign {
    return isRTL ? TextAlign.right : TextAlign.left;
  }

  TextAlign get endTextAlign {
    return isRTL ? TextAlign.left : TextAlign.right;
  }
}
