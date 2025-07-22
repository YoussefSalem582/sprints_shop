import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../providers/localization_provider.dart';
import '../services/analytics_service.dart';
import '../widgets/app_logo_widget.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';
import 'monitoring_dashboard.dart';
import 'language_test_screen.dart';
import 'advanced_shopping_home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });

    // Initialize notifications when welcome screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      final localizationProvider = Provider.of<LocalizationProvider>(
        context,
        listen: false,
      );

      notificationProvider.loadNotifications();
      localizationProvider.loadLocale();

      // Simulate welcome notifications after a short delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          notificationProvider.simulateWelcomeNotifications();
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FBFF), Color(0xFFEBF4FF)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  // Debug button (top right)
                  if (kDebugMode)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: IconButton(
                          icon: Icon(Icons.analytics, color: Colors.grey[600]),
                          onPressed: () async {
                            await AnalyticsService().trackEvent(
                              'monitoring_dashboard_opened',
                              {'source': 'welcome_screen'},
                            );
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MonitoringDashboard(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                  // Main content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo section
                        SlideTransition(
                          position: _slideAnimation,
                          child: const AppLogoWidget.large(showText: false),
                        ),

                        const SizedBox(height: 40),

                        // Welcome text
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Opacity(opacity: value, child: child);
                          },
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.appTitle,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.welcomeSubtitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),

                        // Action buttons
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 1000),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Column(
                            children: [
                              // Primary button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await AnalyticsService().trackEvent(
                                      'sign_up_button_clicked',
                                      {'source': 'welcome_screen'},
                                    );
                                    if (mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4C8FC3),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Secondary button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await AnalyticsService().trackEvent(
                                      'sign_in_button_clicked',
                                      {'source': 'welcome_screen'},
                                    );
                                    if (mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1.5,
                                    ),
                                    foregroundColor: Colors.grey[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Guest access
                              TextButton(
                                onPressed: () async {
                                  await AnalyticsService().trackEvent(
                                    'guest_access_clicked',
                                    {'source': 'welcome_screen'},
                                  );
                                  if (mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdvancedShoppingHomeScreen(),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Continue as Guest',
                                  style: TextStyle(
                                    color: const Color(0xFF757575),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Language test button
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LanguageTestScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.language, size: 18),
                                label: const Text('Test Arabic/عربي'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF4C8FC3),
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom spacing
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
