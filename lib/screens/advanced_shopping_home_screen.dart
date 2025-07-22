import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/hot_offer_item.dart';
import '../widgets/search_delegate.dart';
import '../widgets/offline_indicator_widget.dart';
import '../utils/responsive_helper.dart';
import '../providers/localization_provider.dart';
import '../services/analytics_service.dart';
import '../services/performance_service.dart';
import 'cart_screen.dart';
import 'user_profile_screen.dart';
import 'wishlist_screen.dart';

class AdvancedShoppingHomeScreen extends StatefulWidget {
  const AdvancedShoppingHomeScreen({super.key});

  @override
  State<AdvancedShoppingHomeScreen> createState() =>
      _AdvancedShoppingHomeScreenState();
}

class _AdvancedShoppingHomeScreenState extends State<AdvancedShoppingHomeScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _sidebarAnimationController;
  late AnimationController _contentAnimationController;
  late AnimationController _fabAnimationController;

  late Animation<double> _sidebarSlideAnimation;
  late Animation<double> _contentScaleAnimation;
  late Animation<double> _fabRotationAnimation;

  List<Product> _displayedProducts = [];
  bool _isSearchExpanded = false;
  int _selectedCategoryIndex = 0;
  String _selectedSortOption = 'Featured';
  bool _isSidebarOpen = false;

  final List<String> _categories = [
    'All Products',
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports',
    'Books',
    'Beauty',
  ];

  final List<String> _sortOptions = [
    'Featured',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
    'Popular',
    'Rating',
  ];

  @override
  void initState() {
    super.initState();
    _displayedProducts = products;

    // Initialize animation controllers
    _sidebarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize animations
    _sidebarSlideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _sidebarAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _contentScaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _fabRotationAnimation = Tween<double>(begin: 0.0, end: 0.75).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    // Track screen view and performance
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PerformanceService().startTiming('advanced_shopping_home_load');

      await AnalyticsService().trackScreenView('advanced_shopping_home', {
        'products_count': products.length,
        'featured_count': featuredImages.length,
      });

      await PerformanceService().endTiming('advanced_shopping_home_load');
    });
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    _contentAnimationController.dispose();
    _fabAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateDisplayedProducts(List<Product> filteredProducts) {
    setState(() {
      _displayedProducts = filteredProducts;
    });
  }

  void _toggleSidebar() {
    print('Sidebar toggle called. Current state: $_isSidebarOpen');
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });

    if (_isSidebarOpen) {
      print('Opening sidebar');
      _sidebarAnimationController.forward();
      _contentAnimationController.forward();
      _fabAnimationController.forward();
    } else {
      print('Closing sidebar');
      _sidebarAnimationController.reverse();
      _contentAnimationController.reverse();
      _fabAnimationController.reverse();
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    // Filter products based on category
    _toggleSidebar(); // Close sidebar after selection
  }

  void _onSortOptionSelected(String option) {
    setState(() {
      _selectedSortOption = option;
    });
    // Sort products based on option
    _toggleSidebar(); // Close sidebar after selection
  }

  // Sample featured products for PageView
  final List<String> featuredImages = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=200&fit=crop',
    'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&h=200&fit=crop',
    'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=200&fit=crop',
  ];

  // Sample products for GridView
  final List<Product> products = [
    Product(
      id: '1',
      title: 'Wireless Headphones',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=150&h=150&fit=crop',
      price: 99.99,
      description: 'High-quality wireless headphones',
    ),
    Product(
      id: '2',
      title: 'Smart Watch',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=150&h=150&fit=crop',
      price: 199.99,
      description: 'Latest smartwatch with health tracking',
    ),
    Product(
      id: '3',
      title: 'Laptop Bag',
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=150&h=150&fit=crop',
      price: 49.99,
      description: 'Durable laptop bag for professionals',
    ),
    Product(
      id: '4',
      title: 'Coffee Mug',
      imageUrl:
          'https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=150&h=150&fit=crop',
      price: 15.99,
      description: 'Premium ceramic coffee mug',
    ),
    Product(
      id: '5',
      title: 'Bluetooth Speaker',
      imageUrl:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=150&h=150&fit=crop',
      price: 79.99,
      description: 'Portable wireless speaker with premium sound',
    ),
    Product(
      id: '6',
      title: 'Fitness Tracker',
      imageUrl:
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=150&h=150&fit=crop',
      price: 129.99,
      description: 'Advanced fitness tracker with heart rate monitor',
    ),
    Product(
      id: '7',
      title: 'Phone Case',
      imageUrl:
          'https://images.unsplash.com/photo-1601593346740-925612772716?w=150&h=150&fit=crop',
      price: 24.99,
      description: 'Protective phone case',
    ),
    Product(
      id: '8',
      title: 'Sunglasses',
      imageUrl:
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=150&h=150&fit=crop',
      price: 79.99,
      description: 'Stylish UV protection sunglasses',
    ),
  ];

  // Sample hot offers
  final List<HotOffer> hotOffers = [
    HotOffer(
      id: '1',
      title: 'Gaming Keyboard',
      imageUrl:
          'https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=100&h=100&fit=crop',
      description: 'Mechanical gaming keyboard with RGB lighting',
      originalPrice: '\$149.99',
      discountedPrice: '\$99.99',
    ),
    HotOffer(
      id: '2',
      title: 'Bluetooth Speaker',
      imageUrl:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=100&h=100&fit=crop',
      description: 'Portable wireless speaker with premium sound',
      originalPrice: '\$79.99',
      discountedPrice: '\$49.99',
    ),
    HotOffer(
      id: '3',
      title: 'Fitness Tracker',
      imageUrl:
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=100&h=100&fit=crop',
      description: 'Advanced fitness tracker with heart rate monitor',
      originalPrice: '\$199.99',
      discountedPrice: '\$129.99',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        return Directionality(
          textDirection: localizationProvider.textDirection,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppDesignSystem.backgroundLight,
            body: Stack(
              children: [
                // Sidebar
                AnimatedBuilder(
                  animation: _sidebarSlideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        _sidebarSlideAnimation.value *
                            MediaQuery.of(context).size.width *
                            0.85,
                        0,
                      ),
                      child: _buildSidebar(context, localizations),
                    );
                  },
                ),

                // Main Content with Scale Animation
                AnimatedBuilder(
                  animation: _contentScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _contentScaleAnimation.value,
                      child: Transform.translate(
                        offset: Offset(
                          (1 - _contentScaleAnimation.value) *
                              MediaQuery.of(context).size.width *
                              0.3,
                          0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: _contentScaleAnimation.value < 1.0
                                ? BorderRadius.circular(20)
                                : BorderRadius.zero,
                            boxShadow: _contentScaleAnimation.value < 1.0
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(-5, 0),
                                    ),
                                  ]
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: _contentScaleAnimation.value < 1.0
                                ? BorderRadius.circular(20)
                                : BorderRadius.zero,
                            child: _buildMainContent(context, localizations),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Overlay to close sidebar when tapped (only covers main content)
                if (_isSidebarOpen)
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.85,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _toggleSidebar,
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
              ],
            ),
            floatingActionButton: _buildAnimatedFAB(),
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, AppLocalizations localizations) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simplified Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4C8FC3), Color(0xFF3A6B94)],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildSidebarSection('Categories', Icons.category),
                  ..._categories.asMap().entries.map((entry) {
                    int index = entry.key;
                    String category = entry.value;
                    return _buildSidebarItem(
                      title: category,
                      icon: _getCategoryIcon(index),
                      isSelected: _selectedCategoryIndex == index,
                      onTap: () => _onCategorySelected(index),
                    );
                  }).toList(),

                  const SizedBox(height: 16),
                  _buildSidebarSection('Sort By', Icons.sort),
                  ..._sortOptions.map((option) {
                    return _buildSidebarItem(
                      title: option,
                      icon: _getSortIcon(option),
                      isSelected: _selectedSortOption == option,
                      onTap: () => _onSortOptionSelected(option),
                    );
                  }).toList(),

                  const SizedBox(height: 16),
                  _buildSidebarSection('Actions', Icons.settings),
                  _buildSidebarItem(
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () {
                      _toggleSidebar();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSidebarItem(
                    title: 'Cart',
                    icon: Icons.shopping_cart,
                    onTap: () {
                      _toggleSidebar();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSidebarItem(
                    title: 'Wishlist',
                    icon: Icons.favorite,
                    onTap: () {
                      _toggleSidebar();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarSection(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required String title,
    required IconData icon,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : null,
            border: isSelected
                ? Border(right: BorderSide(color: Colors.blue, width: 3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.grey[800],
                  ),
                ),
              ),
              if (isSelected) Icon(Icons.check, size: 16, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSortIcon(String sortOption) {
    switch (sortOption) {
      case 'Featured':
        return Icons.star;
      case 'Price: Low to High':
        return Icons.arrow_upward;
      case 'Price: High to Low':
        return Icons.arrow_downward;
      case 'Newest':
        return Icons.new_releases;
      case 'Popular':
        return Icons.trending_up;
      case 'Rating':
        return Icons.thumb_up;
      default:
        return Icons.sort;
    }
  }

  IconData _getCategoryIcon(int index) {
    switch (index) {
      case 0:
        return Icons.apps;
      case 1:
        return Icons.electrical_services;
      case 2:
        return Icons.checkroom;
      case 3:
        return Icons.home;
      case 4:
        return Icons.sports_soccer;
      case 5:
        return Icons.book;
      case 6:
        return Icons.face_retouching_natural;
      default:
        return Icons.category;
    }
  }

  Widget _buildMainContent(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundLight,
      appBar: _buildAdvancedAppBar(localizations),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFAFCFF), Color(0xFFF0F4F8)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Offline Indicator
              const OfflineIndicatorWidget(),

              // Advanced Welcome Hero Section
              _buildAdvancedWelcomeSection(localizations),

              // Search Section
              if (_isSearchExpanded)
                ProductSearchWidget(
                  products: products,
                  onResults: _updateDisplayedProducts,
                ),

              // Advanced Featured Products Carousel
              _buildAdvancedFeaturedSection(localizations),

              // Hot Offers Section
              _buildAdvancedHotOffersSection(localizations),

              // Advanced Products Grid with Filters
              _buildAdvancedProductsSection(localizations),

              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAdvancedAppBar(AppLocalizations localizations) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4C8FC3), Color(0xFF3A6B94)],
          ),
        ),
      ),
      leading: _buildMenuButton(),
      title: _buildAppBarTitle(localizations),
      centerTitle: true,
    );
  }

  Widget _buildMenuButton() {
    return IconButton(
      onPressed: _toggleSidebar,
      icon: AnimatedBuilder(
        animation: _fabRotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _fabRotationAnimation.value * 2 * 3.14159,
            child: Icon(
              _isSidebarOpen ? Icons.close : Icons.menu,
              color: Colors.white,
              size: 24,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBarTitle(AppLocalizations localizations) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.store_outlined,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          localizations.appTitle,
          style: AppDesignSystem.headingSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedWelcomeSection(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4C8FC3), Color(0xFF3A6B94), Color(0xFF2A5A7D)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C8FC3).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.welcomeTitle,
                          style: AppDesignSystem.headingLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.welcomeSubtitle,
                          style: AppDesignSystem.bodyLarge.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total Products: ${products.length}',
                          style: AppDesignSystem.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFeaturedSection(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppDesignSystem.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [AppDesignSystem.cardShadow],
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured Products',
                        style: AppDesignSystem.headingMedium.copyWith(
                          color: AppDesignSystem.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Handpicked for you',
                        style: AppDesignSystem.bodyMedium.copyWith(
                          color: AppDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${featuredImages.length} items',
                    style: AppDesignSystem.bodySmall.copyWith(
                      color: AppDesignSystem.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              itemCount: featuredImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: AppDesignSystem.cardGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppDesignSystem.primaryBlue.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Image.network(
                          featuredImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 64,
                              ),
                            );
                          },
                        ),
                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Featured Product ${index + 1}',
                                style: AppDesignSystem.headingSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Special offer available',
                                style: AppDesignSystem.bodyMedium.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedHotOffersSection(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFFF5F5), Color(0xFFFFEBEE)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.hotOffers,
                      style: AppDesignSystem.headingMedium.copyWith(
                        color: AppDesignSystem.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Limited time deals',
                      style: AppDesignSystem.bodyMedium.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SALE',
                  style: AppDesignSystem.labelMedium.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hotOffers.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    right: index < hotOffers.length - 1 ? 16 : 0,
                  ),
                  child: HotOfferItem(offer: hotOffers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedProductsSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.ourProducts,
                      style: AppDesignSystem.headingMedium.copyWith(
                        color: AppDesignSystem.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Category: ${_categories[_selectedCategoryIndex]}',
                      style: AppDesignSystem.bodyMedium.copyWith(
                        color: AppDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_displayedProducts.length} items',
                  style: AppDesignSystem.bodySmall.copyWith(
                    color: AppDesignSystem.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Responsive Products Grid
        ResponsiveHelper.isTablet(context)
            ? _buildTabletProductsGrid()
            : _buildMobileProductsGrid(),
      ],
    );
  }

  Widget _buildMobileProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _displayedProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(product: _displayedProducts[index]);
        },
      ),
    );
  }

  Widget _buildTabletProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: _displayedProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(product: _displayedProducts[index]);
        },
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return AnimatedBuilder(
      animation: _fabRotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _fabRotationAnimation.value * 2 * 3.14159,
          child: FloatingActionButton(
            onPressed: _toggleSidebar,
            backgroundColor: AppDesignSystem.primaryBlue,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isSidebarOpen
                  ? const Icon(
                      Icons.close,
                      color: Colors.white,
                      key: ValueKey('close'),
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.white,
                      key: ValueKey('menu'),
                    ),
            ),
          ),
        );
      },
    );
  }
}
