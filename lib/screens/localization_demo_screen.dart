import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/localization_provider.dart';
import '../widgets/localized_widgets.dart';

/// Demonstration screen showing comprehensive Arabic localization features
class LocalizationDemoScreen extends StatelessWidget {
  const LocalizationDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return LocalizedScaffold(
      appBar: LocalizedAppBar(
        title: LocalizedText('Localization Demo'),
        backgroundColor: const Color(0xFF4C8FC3),
        actions: [
          Consumer<LocalizationProvider>(
            builder: (context, localizationProvider, child) {
              return IconButton(
                icon: const Icon(Icons.language),
                onPressed: () {
                  // Toggle between English and Arabic
                  localizationProvider.changeLocale(
                    localizationProvider.currentLocale.languageCode == 'en'
                        ? const Locale('ar')
                        : const Locale('en'),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Toggle Section
            LocalizedCard(
              child: Column(
                children: [
                  LocalizedText(
                    localizations.language,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Consumer<LocalizationProvider>(
                    builder: (context, localizationProvider, child) {
                      return LocalizedRow(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => localizationProvider.changeLocale(
                              const Locale('en'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  localizationProvider
                                          .currentLocale
                                          .languageCode ==
                                      'en'
                                  ? const Color(0xFF4C8FC3)
                                  : Colors.grey,
                            ),
                            child: LocalizedText('English'),
                          ),
                          ElevatedButton(
                            onPressed: () => localizationProvider.changeLocale(
                              const Locale('ar'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  localizationProvider
                                          .currentLocale
                                          .languageCode ==
                                      'ar'
                                  ? const Color(0xFF4C8FC3)
                                  : Colors.grey,
                            ),
                            child: LocalizedText('العربية'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Navigation and UI Elements
            LocalizedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocalizedText(
                    'Navigation Elements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  LocalizedRow(
                    children: [
                      Icon(Icons.home, color: const Color(0xFF4C8FC3)),
                      const SizedBox(width: 8),
                      LocalizedText(localizations.home),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LocalizedRow(
                    children: [
                      Icon(Icons.shopping_cart, color: const Color(0xFF4C8FC3)),
                      const SizedBox(width: 8),
                      LocalizedText(localizations.cart),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LocalizedRow(
                    children: [
                      Icon(Icons.person, color: const Color(0xFF4C8FC3)),
                      const SizedBox(width: 8),
                      LocalizedText(localizations.profile),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LocalizedRow(
                    children: [
                      Icon(Icons.settings, color: const Color(0xFF4C8FC3)),
                      const SizedBox(width: 8),
                      LocalizedText(localizations.settings),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Shopping Features
            LocalizedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocalizedText(
                    localizations.ourProducts,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  LocalizedRow(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.red),
                      const SizedBox(width: 8),
                      LocalizedText(localizations.hotOffers),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LocalizedRow(
                    children: [
                      Icon(
                        Icons.add_shopping_cart,
                        color: const Color(0xFF4C8FC3),
                      ),
                      const SizedBox(width: 8),
                      LocalizedText(localizations.addToCart),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LocalizedRow(
                    children: [
                      Icon(Icons.payment, color: const Color(0xFF4C8FC3)),
                      const SizedBox(width: 8),
                      LocalizedText(localizations.checkout),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Text Input Demonstration
            LocalizedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocalizedText(
                    'Text Input (RTL Support)',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  LocalizedTextFormField(
                    labelText: localizations.fullName,
                    hintText: localizations.pleaseEnterFullName,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  LocalizedTextFormField(
                    labelText: localizations.email,
                    hintText: localizations.pleaseEnterEmail,
                    prefixIcon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  LocalizedTextFormField(
                    labelText: localizations.search,
                    hintText: localizations.searchProducts,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Currency and Numbers
            LocalizedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocalizedText(
                    'Currency & Numbers',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Consumer<LocalizationProvider>(
                    builder: (context, localizationProvider, child) {
                      return Column(
                        children: [
                          LocalizedRow(
                            children: [
                              LocalizedText('${localizations.price}: '),
                              LocalizedText(
                                localizationProvider.formatCurrency(99.99),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LocalizedRow(
                            children: [
                              LocalizedText('${localizations.total}: '),
                              LocalizedText(
                                localizationProvider.formatCurrency(299.97),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4C8FC3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LocalizedRow(
                            children: [
                              LocalizedText('Date: '),
                              LocalizedText(
                                localizationProvider.formatDate(DateTime.now()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Test All Screens Button
            LocalizedCard(
              child: Column(
                children: [
                  LocalizedText(
                    'Test Navigation',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/shopping'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C8FC3),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: LocalizedText(
                        localizations.ourProducts,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C8FC3),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: LocalizedText(
                        localizations.cart,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
