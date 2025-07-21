import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const SprintsShopApp());
}

class SprintsShopApp extends StatelessWidget {
  const SprintsShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprints Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Suwannaphum', // Will fallback to default if not available
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Localization support
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      home: const WelcomeScreen(),
    );
  }
}
