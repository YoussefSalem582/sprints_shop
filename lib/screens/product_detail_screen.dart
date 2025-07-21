import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/responsive_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with Product Image
          SliverAppBar(
            expandedHeight: ResponsiveHelper.responsive(
              context,
              mobile: 250.0,
              tablet: 350.0,
              desktop: 400.0,
            ),
            pinned: true,
            backgroundColor: Colors.blue[700],
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Product Details
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: ResponsiveHelper.responsivePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        widget.product.title,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getTextSize(context, 28),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Price and Rating Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          // Mock Rating
                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < 4 ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 20,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                '4.0 (124 reviews)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Description Section
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        widget.product.description.isNotEmpty
                            ? widget.product.description
                            : 'This is a high-quality product with excellent features. Perfect for everyday use and built to last. Features include premium materials, modern design, and exceptional value for money.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Features Section
                      _buildFeaturesSection(),

                      const SizedBox(height: 30),

                      // Reviews Section
                      _buildReviewsSection(),

                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating Add to Cart Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Consumer<CartProvider>(
          builder: (ctx, cart, child) => Row(
            children: [
              // Quantity in Cart
              if (cart.isInCart(widget.product.id))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    'In Cart: ${cart.getProductQuantity(widget.product.id)}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              if (cart.isInCart(widget.product.id)) const SizedBox(width: 12),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    cart.addItem(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.title} added to cart!'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                        action: SnackBarAction(
                          label: 'VIEW CART',
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/cart');
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {
        'icon': Icons.verified,
        'title': 'Quality Guaranteed',
        'subtitle': 'Premium materials',
      },
      {
        'icon': Icons.local_shipping,
        'title': 'Free Shipping',
        'subtitle': 'On orders over \$50',
      },
      {
        'icon': Icons.replay,
        'title': 'Easy Returns',
        'subtitle': '30-day return policy',
      },
      {
        'icon': Icons.support_agent,
        'title': '24/7 Support',
        'subtitle': 'Customer service',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        ...features.map(
          (feature) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  feature['icon'] as IconData,
                  color: Colors.blue[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        feature['subtitle'] as String,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
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

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all reviews
              },
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Sample Reviews
        ...List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        ['J', 'S'][index],
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ['John Doe', 'Sarah Smith'][index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (starIndex) => Icon(
                                  starIndex < [5, 4][index]
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '2 days ago',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  [
                    'Excellent product! Really happy with the quality and fast delivery.',
                    'Good value for money. Exactly as described in the product details.',
                  ][index],
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
