import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/hot_offer_item.dart';
import '../widgets/search_delegate.dart';
import '../widgets/notification_widgets.dart';
import '../widgets/localization_widgets.dart';
import '../widgets/offline_indicator_widget.dart';
import '../widgets/camera_service_widget.dart';
import '../widgets/location_service_widget.dart';
import '../widgets/notification_settings_widget.dart';
import '../utils/responsive_helper.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/localization_provider.dart';
import '../services/analytics_service.dart';
import '../services/performance_service.dart';
import 'cart_screen.dart';
import 'user_profile_screen.dart';
import 'wishlist_screen.dart';

class ShoppingHomeScreen extends StatefulWidget {
  const ShoppingHomeScreen({super.key});

  @override
  State<ShoppingHomeScreen> createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen> {
  final PageController _pageController = PageController();
  List<Product> _displayedProducts = [];
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _displayedProducts = products;

    // Track screen view and performance
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PerformanceService().startTiming('shopping_home_load');

      await AnalyticsService().trackScreenView('shopping_home', {
        'products_count': products.length,
        'featured_count': featuredImages.length,
      });

      await PerformanceService().endTiming('shopping_home_load');
    });
  }

  void _updateDisplayedProducts(List<Product> filteredProducts) {
    setState(() {
      _displayedProducts = filteredProducts;
    });
  }

  // Sample featured products for PageView
  final List<String> featuredImages = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=200&fit=crop',
    'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&h=200&fit=crop',
    'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop',
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
      title: 'Phone Case',
      imageUrl:
          'https://images.unsplash.com/photo-1601593346740-925612772716?w=150&h=150&fit=crop',
      price: 24.99,
      description: 'Protective phone case',
    ),
    Product(
      id: '6',
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
    HotOffer(
      id: '4',
      title: 'Wireless Mouse',
      imageUrl:
          'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=100&h=100&fit=crop',
      description: 'Ergonomic wireless mouse for productivity',
      originalPrice: '\$59.99',
      discountedPrice: '\$34.99',
    ),
    HotOffer(
      id: '5',
      title: 'Power Bank',
      imageUrl:
          'https://images.unsplash.com/photo-1609592352083-22ce1a7e4c2f?w=100&h=100&fit=crop',
      description: 'High-capacity portable power bank',
      originalPrice: '\$39.99',
      discountedPrice: '\$24.99',
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
            appBar: LogoAppBar(
              titleKey: 'our_products',
              backgroundColor: const Color(0xFF4C8FC3),
              actions: [
                const NotificationIcon(),
                IconButton(
                  icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = !_isSearchExpanded;
                      if (!_isSearchExpanded) {
                        _displayedProducts = products;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserProfileScreen(),
                      ),
                    );
                  },
                ),
                Consumer<WishlistProvider>(
                  builder: (ctx, wishlist, child) => Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const WishlistScreen(),
                            ),
                          );
                        },
                      ),
                      if (wishlist.itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${wishlist.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (ctx, cart, child) => Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Offline Indicator
                  const OfflineIndicatorWidget(),

                  // Search Section
                  if (_isSearchExpanded)
                    ProductSearchWidget(
                      products: products,
                      onResults: _updateDisplayedProducts,
                    ),

                  // Featured Products PageView
                  Container(
                    height: ResponsiveHelper.responsive(
                      context,
                      mobile: 200.0,
                      tablet: 250.0,
                      desktop: 300.0,
                    ),
                    margin: ResponsiveHelper.responsivePadding(context),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: featuredImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              featuredImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Products Grid
                  Padding(
                    padding: ResponsiveHelper.responsivePadding(context),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveHelper.getGridColumns(
                          context,
                        ),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: ResponsiveHelper.isMobile(context)
                            ? 0.8
                            : 0.9,
                      ),
                      itemCount: _displayedProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: _displayedProducts[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Hot Offers Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          localizations.hotOffers,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4C8FC3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Hot Offers ListView
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: hotOffers.length,
                      itemBuilder: (context, index) {
                        return HotOfferItem(offer: hotOffers[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            floatingActionButton: _buildFloatingActionMenu(),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "notifications",
          mini: true,
          backgroundColor: Colors.purple,
          onPressed: () {
            _showNotificationSettings();
          },
          child: const Icon(Icons.notifications_outlined),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: "location",
          mini: true,
          backgroundColor: Colors.green,
          onPressed: () {
            _showLocationDialog();
          },
          child: const Icon(Icons.location_on),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: "camera",
          mini: true,
          backgroundColor: Colors.blue,
          onPressed: () {
            _showCameraDialog();
          },
          child: const Icon(Icons.camera_alt),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: "main",
          backgroundColor: Colors.orange,
          onPressed: () {
            // Main action - could be quick add to cart or product search
          },
          child: const Icon(Icons.add_shopping_cart),
        ),
      ],
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 600,
          width: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.notifications,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: SingleChildScrollView(
                  child: NotificationSettingsWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(child: CameraServiceWidget()),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(child: LocationServiceWidget()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
