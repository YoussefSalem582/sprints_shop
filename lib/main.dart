import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/order_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/localization_provider.dart';
import 'providers/connectivity_provider.dart';
import 'services/offline_storage_service.dart';
import 'services/native_features_service.dart';
import 'services/analytics_service.dart';
import 'services/performance_service.dart';
import 'services/crash_reporting_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize crash reporting first
  await CrashReportingService().initialize();

  // Initialize performance monitoring
  await PerformanceService().initialize();

  // Initialize analytics
  await AnalyticsService().initialize();

  // Track app startup performance
  PerformanceService().startTiming('app_startup');

  try {
    // Initialize offline storage
    await OfflineStorageService.database;
    await OfflineStorageService.clearExpiredCache();

    // Track successful storage initialization
    await AnalyticsService().trackEvent('storage_initialized', {
      'success': true,
    });
  } catch (e) {
    debugPrint('Failed to initialize offline storage: $e');
    await CrashReportingService().reportError(
      error: e,
      context: 'Storage Initialization',
    );
  }

  // Request permissions on startup
  if (NativeFeaturesService.isPhysicalDevice) {
    try {
      await NativeFeaturesService.requestAllPermissions();
      await AnalyticsService().trackEvent('permissions_requested', {
        'is_physical_device': true,
      });
    } catch (e) {
      await CrashReportingService().reportError(
        error: e,
        context: 'Permission Request',
      );
    }
  }

  // End startup timing
  await PerformanceService().endTiming('app_startup', {
    'platform': 'android', // We can determine this from the build context
  });

  runApp(const SprintsShopApp());
}

class SprintsShopApp extends StatelessWidget {
  const SprintsShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => WishlistProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
        ChangeNotifierProvider(create: (ctx) => NotificationProvider()),
        ChangeNotifierProvider(create: (ctx) => LocalizationProvider()),
        ChangeNotifierProvider(create: (ctx) => ConnectivityProvider()),
      ],
      child: Consumer2<ThemeProvider, LocalizationProvider>(
        builder: (context, themeProvider, localizationProvider, child) {
          return MaterialApp(
            title: 'Sprints Shop',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            locale: localizationProvider.currentLocale,
            // Localization support
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationProvider.supportedLocales,
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
