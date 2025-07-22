import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/localization_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageTestScreen extends StatelessWidget {
  const LanguageTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        backgroundColor: const Color(0xFF4C8FC3),
        foregroundColor: Colors.white,
      ),
      body: Directionality(
        textDirection: localizationProvider.textDirection,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language toggle button
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(
                    localizationProvider.isArabic ? 'اللغة' : 'Language',
                  ),
                  subtitle: Text(
                    localizationProvider.isArabic ? 'العربية' : 'English',
                  ),
                  trailing: Switch(
                    value: localizationProvider.isArabic,
                    onChanged: (value) {
                      localizationProvider.toggleLanguage();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sample text to demonstrate localization
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.welcomeTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.welcomeSubtitle,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C8FC3),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(localizations.signUp),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF4C8FC3),
                                ),
                                foregroundColor: const Color(0xFF4C8FC3),
                              ),
                              child: Text(localizations.signIn),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Currency and date formatting demo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizationProvider.isArabic
                            ? 'تنسيق العملة والتاريخ'
                            : 'Currency & Date Formatting',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${localizationProvider.isArabic ? 'السعر:' : 'Price:'} ${localizationProvider.formatCurrency(99.99)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${localizationProvider.isArabic ? 'التاريخ:' : 'Date:'} ${localizationProvider.formatDate(DateTime.now())}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${localizationProvider.isArabic ? 'الوقت:' : 'Time:'} ${localizationProvider.formatTime(DateTime.now())}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Text direction demo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizationProvider.isArabic
                            ? 'اتجاه النص'
                            : 'Text Direction',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          localizationProvider.isArabic
                              ? 'هذا نص تجريبي باللغة العربية يظهر من اليمين إلى اليسار'
                              : 'This is sample text in English showing left-to-right direction',
                          textAlign: localizationProvider.startTextAlign,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
