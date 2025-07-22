import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'shopping_home_screen.dart';
import 'advanced_shopping_home_screen.dart';

class HomeScreenDemoScreen extends StatelessWidget {
  const HomeScreenDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4C8FC3), Color(0xFF3A6B94), Color(0xFF2A5A7D)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.store, color: Colors.white, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        localizations.appTitle,
                        style: AppDesignSystem.headingLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose Your Shopping Experience',
                        style: AppDesignSystem.bodyLarge.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Home Screen Options
                Column(
                  children: [
                    // Original Home Screen
                    _buildHomeScreenOption(
                      context: context,
                      title: 'Enhanced Home Screen',
                      subtitle: 'Modern design with gradients and enhanced UI',
                      icon: Icons.home,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4C8FC3), Color(0xFF3A6B94)],
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ShoppingHomeScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Advanced Home Screen
                    _buildHomeScreenOption(
                      context: context,
                      title: 'Advanced Home Screen',
                      subtitle: 'Sidebar navigation with advanced animations',
                      icon: Icons.dashboard,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                const AdvancedShoppingHomeScreen(),
                          ),
                        );
                      },
                      isRecommended: true,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Footer
                Text(
                  'Both versions include full localization support\\nand responsive design',
                  style: AppDesignSystem.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScreenOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
    bool isRecommended = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Background Pattern
                if (isRecommended)
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'RECOMMENDED',
                        style: AppDesignSystem.labelMedium.copyWith(
                          color: gradient.colors.first,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Content
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppDesignSystem.headingSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: AppDesignSystem.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
