import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../providers/localization_provider.dart';
import 'shopping_home_screen.dart';
import 'cart_screen.dart';
import 'user_profile_screen.dart';
import 'ui_enhancement_demo_screen.dart';

/// Enhanced main navigation with modern bottom tab bar
class EnhancedMainNavigation extends StatefulWidget {
  const EnhancedMainNavigation({super.key});

  @override
  State<EnhancedMainNavigation> createState() => _EnhancedMainNavigationState();
}

class _EnhancedMainNavigationState extends State<EnhancedMainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late List<Animation<double>> _iconAnimations;

  final List<Widget> _screens = [
    const ShoppingHomeScreen(),
    const CartScreen(),
    const UserProfileScreen(),
    const UIEnhancementDemoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        return Directionality(
          textDirection: localizationProvider.textDirection,
          child: Scaffold(
            body: IndexedStack(index: _currentIndex, children: _screens),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFFAFCFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spaceMD,
                    vertical: AppDesignSystem.spaceSM,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        index: 0,
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        label: localizations.home,
                      ),
                      _buildNavItem(
                        index: 1,
                        icon: Icons.shopping_cart_outlined,
                        activeIcon: Icons.shopping_cart,
                        label: localizations.cart,
                        showBadge: true,
                      ),
                      _buildNavItem(
                        index: 2,
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: localizations.profile,
                      ),
                      _buildNavItem(
                        index: 3,
                        icon: Icons.palette_outlined,
                        activeIcon: Icons.palette,
                        label: 'UI Demo',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    bool showBadge = false,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: AnimatedBuilder(
        animation: _iconAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _iconAnimations[index].value : 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignSystem.spaceMD,
                vertical: AppDesignSystem.spaceSM,
              ),
              decoration: BoxDecoration(
                gradient: isSelected ? AppDesignSystem.primaryGradient : null,
                borderRadius: AppDesignSystem.radiusLarge,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppDesignSystem.primaryBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Icon(
                        isSelected ? activeIcon : icon,
                        color: isSelected
                            ? Colors.white
                            : AppDesignSystem.textMuted,
                        size: 24,
                      ),
                      if (showBadge && index == 1)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              if (cartProvider.itemCount == 0) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppDesignSystem.accentRed,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${cartProvider.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppDesignSystem.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
