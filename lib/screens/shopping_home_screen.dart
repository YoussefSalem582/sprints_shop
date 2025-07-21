import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/hot_offer_item.dart';

class ShoppingHomeScreen extends StatefulWidget {
  const ShoppingHomeScreen({super.key});

  @override
  State<ShoppingHomeScreen> createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen> {
  final PageController _pageController = PageController();
  
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
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=150&h=150&fit=crop',
      price: 99.99,
      description: 'High-quality wireless headphones',
    ),
    Product(
      id: '2',
      title: 'Smart Watch',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=150&h=150&fit=crop',
      price: 199.99,
      description: 'Latest smartwatch with health tracking',
    ),
    Product(
      id: '3',
      title: 'Laptop Bag',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=150&h=150&fit=crop',
      price: 49.99,
      description: 'Durable laptop bag for professionals',
    ),
    Product(
      id: '4',
      title: 'Coffee Mug',
      imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=150&h=150&fit=crop',
      price: 15.99,
      description: 'Premium ceramic coffee mug',
    ),
    Product(
      id: '5',
      title: 'Phone Case',
      imageUrl: 'https://images.unsplash.com/photo-1601593346740-925612772716?w=150&h=150&fit=crop',
      price: 24.99,
      description: 'Protective phone case',
    ),
    Product(
      id: '6',
      title: 'Sunglasses',
      imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=150&h=150&fit=crop',
      price: 79.99,
      description: 'Stylish UV protection sunglasses',
    ),
  ];

  // Sample hot offers
  final List<HotOffer> hotOffers = [
    HotOffer(
      id: '1',
      title: 'Gaming Keyboard',
      imageUrl: 'https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=100&h=100&fit=crop',
      description: 'Mechanical gaming keyboard with RGB lighting',
      originalPrice: '\$149.99',
      discountedPrice: '\$99.99',
    ),
    HotOffer(
      id: '2',
      title: 'Bluetooth Speaker',
      imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=100&h=100&fit=crop',
      description: 'Portable wireless speaker with premium sound',
      originalPrice: '\$79.99',
      discountedPrice: '\$49.99',
    ),
    HotOffer(
      id: '3',
      title: 'Fitness Tracker',
      imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=100&h=100&fit=crop',
      description: 'Advanced fitness tracker with heart rate monitor',
      originalPrice: '\$199.99',
      discountedPrice: '\$129.99',
    ),
    HotOffer(
      id: '4',
      title: 'Wireless Mouse',
      imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=100&h=100&fit=crop',
      description: 'Ergonomic wireless mouse for productivity',
      originalPrice: '\$59.99',
      discountedPrice: '\$34.99',
    ),
    HotOffer(
      id: '5',
      title: 'Power Bank',
      imageUrl: 'https://images.unsplash.com/photo-1609592352083-22ce1a7e4c2f?w=100&h=100&fit=crop',
      description: 'High-capacity portable power bank',
      originalPrice: '\$39.99',
      discountedPrice: '\$24.99',
    ),
  ];

  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Cart functionality can be added here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Products PageView
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                    onAddToCart: () => _addToCart(products[index]),
                  );
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
                    'Hot Offers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
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
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
