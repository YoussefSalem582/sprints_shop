import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/localization_provider.dart';
import '../l10n/app_localizations.dart';

/// Enhanced UI Demo Screen showcasing modern design improvements
class UIEnhancementDemoScreen extends StatelessWidget {
  const UIEnhancementDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppDesignSystem.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(context, localizations),

                const SizedBox(height: AppDesignSystem.spaceXL),

                // Modern Cards Section
                _buildModernCardsSection(context, localizations),

                const SizedBox(height: AppDesignSystem.spaceXL),

                // Buttons Section
                _buildButtonsSection(context, localizations),

                const SizedBox(height: AppDesignSystem.spaceXL),

                // Chips Section
                _buildChipsSection(context, localizations),

                const SizedBox(height: AppDesignSystem.spaceXL),

                // Color Palette Section
                _buildColorPaletteSection(context, localizations),

                const SizedBox(height: AppDesignSystem.spaceXL),

                // Product Card Preview
                _buildProductCardPreview(context, localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return ModernCard(
      gradient: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  gradient: AppDesignSystem.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.palette, color: Colors.white, size: 28),
              ),
              const SizedBox(width: AppDesignSystem.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UI Enhancement Demo',
                      style: AppDesignSystem.headingMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Modern design system showcase',
                      style: AppDesignSystem.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernCardsSection(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Modern Cards', style: AppDesignSystem.headingSmall),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Row(
          children: [
            Expanded(
              child: ModernCard(
                child: Column(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppDesignSystem.accentGreen,
                      size: 32,
                    ),
                    const SizedBox(height: AppDesignSystem.spaceSM),
                    Text('Sales', style: AppDesignSystem.labelLarge),
                    Text(
                      '+23%',
                      style: AppDesignSystem.headingSmall.copyWith(
                        color: AppDesignSystem.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: ModernCard(
                elevated: true,
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: AppDesignSystem.primaryBlue,
                      size: 32,
                    ),
                    const SizedBox(height: AppDesignSystem.spaceSM),
                    Text('Orders', style: AppDesignSystem.labelLarge),
                    Text(
                      '1,234',
                      style: AppDesignSystem.headingSmall.copyWith(
                        color: AppDesignSystem.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsSection(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Modern Buttons', style: AppDesignSystem.headingSmall),
        const SizedBox(height: AppDesignSystem.spaceMD),
        ModernCard(
          child: Column(
            children: [
              ModernButton(
                text: 'Primary Button',
                icon: Icons.star,
                width: double.infinity,
                onPressed: () {},
              ),
              const SizedBox(height: AppDesignSystem.spaceMD),
              ModernButton(
                text: 'Secondary Button',
                icon: Icons.favorite,
                width: double.infinity,
                isSecondary: true,
                onPressed: () {},
              ),
              const SizedBox(height: AppDesignSystem.spaceMD),
              ModernButton(
                text: 'Outlined Button',
                icon: Icons.info,
                width: double.infinity,
                isOutlined: true,
                onPressed: () {},
              ),
              const SizedBox(height: AppDesignSystem.spaceMD),
              ModernButton(
                text: 'Loading...',
                width: double.infinity,
                loading: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChipsSection(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Modern Chips', style: AppDesignSystem.headingSmall),
        const SizedBox(height: AppDesignSystem.spaceMD),
        ModernCard(
          child: Wrap(
            spacing: AppDesignSystem.spaceSM,
            runSpacing: AppDesignSystem.spaceSM,
            children: [
              ModernChip(
                label: 'Selected',
                icon: Icons.check,
                selected: true,
                onTap: () {},
              ),
              ModernChip(
                label: 'Electronics',
                icon: Icons.devices,
                onTap: () {},
              ),
              ModernChip(
                label: 'Fashion',
                icon: Icons.style,
                color: AppDesignSystem.secondaryOrange,
                onTap: () {},
              ),
              ModernChip(
                label: 'Home & Garden',
                icon: Icons.home,
                color: AppDesignSystem.accentGreen,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorPaletteSection(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color Palette', style: AppDesignSystem.headingSmall),
        const SizedBox(height: AppDesignSystem.spaceMD),
        ModernCard(
          child: Column(
            children: [
              _buildColorRow([
                ('Primary Blue', AppDesignSystem.primaryBlue),
                ('Primary Dark', AppDesignSystem.primaryBlueDark),
                ('Primary Light', AppDesignSystem.primaryBlueLight),
              ]),
              const SizedBox(height: AppDesignSystem.spaceMD),
              _buildColorRow([
                ('Secondary Orange', AppDesignSystem.secondaryOrange),
                ('Accent Green', AppDesignSystem.accentGreen),
                ('Accent Red', AppDesignSystem.accentRed),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorRow(List<(String, Color)> colors) {
    return Row(
      children: colors.map((colorData) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorData.$2,
                    borderRadius: AppDesignSystem.radiusSmall,
                    border: Border.all(color: AppDesignSystem.borderLight),
                  ),
                ),
                const SizedBox(height: AppDesignSystem.spaceSM),
                Text(
                  colorData.$1,
                  style: AppDesignSystem.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductCardPreview(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enhanced Product Card Preview',
          style: AppDesignSystem.headingSmall,
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Container(
          height: 320,
          child: ModernCard(
            gradient: true,
            elevated: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Area
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppDesignSystem.primaryBlue.withOpacity(0.1),
                          AppDesignSystem.secondaryOrange.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: AppDesignSystem.radiusMedium,
                    ),
                    child: const Icon(
                      Icons.devices,
                      size: 64,
                      color: AppDesignSystem.primaryBlue,
                    ),
                  ),
                ),

                const SizedBox(height: AppDesignSystem.spaceMD),

                // Product Details
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sample Product', style: AppDesignSystem.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Modern design with enhanced styling',
                        style: AppDesignSystem.bodySmall,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$99.99',
                            style: AppDesignSystem.headingSmall.copyWith(
                              color: AppDesignSystem.primaryBlue,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              gradient: AppDesignSystem.primaryGradient,
                              borderRadius: AppDesignSystem.radiusSmall,
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
