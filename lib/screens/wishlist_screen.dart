import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/loading_widgets.dart';
import '../screens/product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          Consumer<WishlistProvider>(
            builder: (ctx, wishlist, child) => wishlist.itemCount > 0
                ? IconButton(
                    icon: const Icon(Icons.clear_all),
                    onPressed: () =>
                        _showClearWishlistDialog(context, wishlist),
                  )
                : Container(),
          ),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (ctx, wishlist, child) {
          if (wishlist.isEmpty) {
            return EmptyStateWidget(
              title: 'Your wishlist is empty',
              message: 'Add products to your wishlist to see them here!',
              icon: Icons.favorite_outline,
              actionLabel: 'Start Shopping',
              onAction: () => Navigator.of(context).pop(),
            );
          }

          return Column(
            children: [
              // Wishlist header
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      '${wishlist.itemCount} item${wishlist.itemCount != 1 ? 's' : ''} in your wishlist',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Wishlist items
              Expanded(
                child: ListView.builder(
                  itemCount: wishlist.items.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (ctx, i) =>
                      _buildWishlistItem(context, wishlist.items[i], wishlist),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    product,
    WishlistProvider wishlist,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              Hero(
                tag: 'product-${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: NetworkImageWithLoader(
                    imageUrl: product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  // Remove from wishlist
                  IconButton(
                    onPressed: () {
                      wishlist.removeItem(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.title} removed from wishlist',
                          ),
                          backgroundColor: Colors.orange,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite),
                    color: Colors.red,
                  ),

                  // Add to cart
                  Consumer<CartProvider>(
                    builder: (ctx, cart, child) => IconButton(
                      onPressed: () {
                        cart.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'UNDO',
                              textColor: Colors.white,
                              onPressed: () =>
                                  cart.removeSingleItem(product.id),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearWishlistDialog(
    BuildContext context,
    WishlistProvider wishlist,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text(
          'Are you sure you want to remove all items from your wishlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              wishlist.clearWishlist();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wishlist cleared successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
