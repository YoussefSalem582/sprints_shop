import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/analytics_service.dart';
import '../services/performance_service.dart';
import '../screens/product_detail_screen.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFAFCFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4C8FC3).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: InkWell(
            onTap: () async {
              PerformanceService().startTiming('product_navigation');

              await AnalyticsService().trackProductView(
                productId: product.id,
                productName: product.title,
                price: product.price,
                category:
                    'general', // Since Product model doesn't have category
              );

              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              }

              await PerformanceService().endTiming('product_navigation');
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Hero(
                          tag: 'product-${product.id}',
                          child: Image.network(
                            product.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Wishlist button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Consumer<WishlistProvider>(
                          builder: (ctx, wishlist, child) => CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                wishlist.isInWishlist(product.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: wishlist.isInWishlist(product.id)
                                    ? Colors.red
                                    : Colors.grey,
                                size: 18,
                              ),
                              onPressed: () {
                                wishlist.toggleItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      wishlist.isInWishlist(product.id)
                                          ? '${product.title} added to wishlist!'
                                          : '${product.title} removed from wishlist!',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor:
                                        wishlist.isInWishlist(product.id)
                                        ? Colors.red
                                        : Colors.orange,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Product Details
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product Title
                        Flexible(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 2),

                        // Product Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),

                        const Spacer(),

                        // Add to Cart Button
                        Consumer<CartProvider>(
                          builder: (ctx, cart, child) => SizedBox(
                            width: double.infinity,
                            height: 28,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                cart.addItem(product);

                                // Track add to cart analytics
                                await AnalyticsService().trackAddToCart(
                                  productId: product.id,
                                  productName: product.title,
                                  price: product.price,
                                  quantity: 1,
                                );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.title} added to cart!',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                size: 14,
                              ),
                              label: const Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: 10),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
