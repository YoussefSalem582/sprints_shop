import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/order_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/localization_provider.dart';
import 'providers/connectivity_provider.dart';
import 'services/offline_storage_service.dart';
import 'services/native_features_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline storage
  try {
    await OfflineStorageService.database;
    await OfflineStorageService.clearExpiredCache();
  } catch (e) {
    debugPrint('Failed to initialize offline storage: $e');
  }

  // Request permissions on startup
  if (NativeFeaturesService.isPhysicalDevice) {
    NativeFeaturesService.requestAllPermissions();
  }

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
