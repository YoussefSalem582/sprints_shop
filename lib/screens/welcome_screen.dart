import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../providers/localization_provider.dart';
import '../services/analytics_service.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';
import 'monitoring_dashboard.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sprints Shop',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.analytics, color: Colors.white),
              onPressed: () async {
                await AnalyticsService().trackEvent(
                  'monitoring_dashboard_opened',
                  {'source': 'welcome_screen'},
                );
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonitoringDashboard(),
                    ),
                  );
                }
              },
              tooltip: 'Monitoring Dashboard',
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Two images in a row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Local image placeholder
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: Colors.blue,
                      ),
                    ),
                    // Online image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=120&h=120&fit=crop',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 60,
                                color: Colors.blue,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Welcome text with custom styling
                const Text(
                  'Welcome to Sprints Shop',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Your one-stop destination for amazing products',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // Sign-up button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign-in button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue[700]!, width: 2),
                      foregroundColor: Colors.blue[700],
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
