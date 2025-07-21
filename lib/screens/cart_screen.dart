import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../utils/responsive_helper.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (cart.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => _showClearCartDialog(context, cart),
            ),
        ],
      ),
      body: cart.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) =>
                        _buildCartItem(context, cart.items[i], cart),
                  ),
                ),
                _buildCartSummary(context, cart),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add some products to get started!',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, cartItem, CartProvider cart) {
    return Card(
      margin: ResponsiveHelper.responsiveMargin(context),
      child: Padding(
        padding: ResponsiveHelper.responsivePadding(context),
        child: ResponsiveHelper.isMobile(context)
            ? _buildMobileCartItem(context, cartItem, cart)
            : _buildDesktopCartItem(context, cartItem, cart),
      ),
    );
  }

  Widget _buildMobileCartItem(
    BuildContext context,
    cartItem,
    CartProvider cart,
  ) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(cartItem.imageUrl),
        backgroundColor: Colors.grey[200],
      ),
      title: Text(
        cartItem.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: \$${cartItem.price.toStringAsFixed(2)}'),
          const SizedBox(height: 5),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: cartItem.quantity > 1
                    ? () => cart.removeSingleItem(cartItem.productId)
                    : null,
                color: cartItem.quantity > 1 ? Colors.blue : Colors.grey,
              ),
              Text(
                '${cartItem.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => cart.addItem(
                  Product(
                    id: cartItem.productId,
                    title: cartItem.title,
                    description: '',
                    price: cartItem.price,
                    imageUrl: cartItem.imageUrl,
                  ),
                ),
                color: Colors.blue,
              ),
              const Spacer(),
              Text(
                '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => cart.removeItem(cartItem.productId),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCartItem(
    BuildContext context,
    cartItem,
    CartProvider cart,
  ) {
    return Row(
      children: [
        // Product Image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(cartItem.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Product Details
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: \$${cartItem.price.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        // Quantity Controls
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: cartItem.quantity > 1
                    ? () => cart.removeSingleItem(cartItem.productId)
                    : null,
                color: cartItem.quantity > 1 ? Colors.blue : Colors.grey,
              ),
              Text(
                '${cartItem.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => cart.addItem(
                  Product(
                    id: cartItem.productId,
                    title: cartItem.title,
                    description: '',
                    price: cartItem.price,
                    imageUrl: cartItem.imageUrl,
                  ),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ),
        // Total & Remove
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => cart.removeItem(cartItem.productId),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: ResponsiveHelper.responsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ResponsiveHelper.isMobile(context)
          ? _buildMobileCartSummary(context, cart)
          : _buildDesktopCartSummary(context, cart),
    );
  }

  Widget _buildMobileCartSummary(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${cart.itemCount}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${cart.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PaymentScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopCartSummary(BuildContext context, CartProvider cart) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              const Text(
                'Total Items: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${cart.itemCount}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40),
              const Text(
                'Total Amount: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PaymentScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
            onPressed: () {
              cart.clearCart();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
