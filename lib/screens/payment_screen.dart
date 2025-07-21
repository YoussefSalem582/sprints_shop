import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/notification_provider.dart';
import '../screens/order_history_screen.dart';
import '../widgets/loading_widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'credit_card';
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: _isProcessing
          ? const LoadingWidget(message: 'Processing payment...')
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    _buildOrderSummary(cart),

                    const SizedBox(height: 24),

                    // Payment Methods
                    _buildPaymentMethods(),

                    const SizedBox(height: 24),

                    // Payment Form
                    if (_selectedPaymentMethod == 'credit_card')
                      _buildCreditCardForm(),

                    if (_selectedPaymentMethod == 'paypal')
                      _buildPayPalSection(),

                    if (_selectedPaymentMethod == 'apple_pay')
                      _buildApplePaySection(),

                    const SizedBox(height: 32),

                    // Pay Button
                    _buildPayButton(cart),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items (${cart.totalQuantity})'),
                Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Shipping'), Text('Free')],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Tax'), Text('\$0.00')],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      {
        'id': 'credit_card',
        'title': 'Credit Card',
        'subtitle': 'Visa, MasterCard, American Express',
        'icon': Icons.credit_card,
      },
      {
        'id': 'paypal',
        'title': 'PayPal',
        'subtitle': 'Pay with your PayPal account',
        'icon': Icons.account_balance_wallet,
      },
      {
        'id': 'apple_pay',
        'title': 'Apple Pay',
        'subtitle': 'Touch ID or Face ID required',
        'icon': Icons.phone_android,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...paymentMethods.map(
              (method) => RadioListTile<String>(
                value: method['id'] as String,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                title: Text(method['title'] as String),
                subtitle: Text(method['subtitle'] as String),
                secondary: Icon(method['icon'] as IconData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Card Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Card Number
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  // Expiry Date
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'MM/YY',
                        hintText: '12/25',
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // CVV
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Cardholder Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'John Doe',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayPalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'You will be redirected to PayPal to complete your payment',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Mock PayPal integration
                _showComingSoonDialog('PayPal Integration');
              },
              icon: const Icon(Icons.launch),
              label: const Text('Continue with PayPal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplePaySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.phone_android, size: 48, color: Colors.black),
            const SizedBox(height: 16),
            const Text(
              'Use Touch ID or Face ID to pay with Apple Pay',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Mock Apple Pay integration
                _showComingSoonDialog('Apple Pay Integration');
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text('Pay with Apple Pay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(CartProvider cart) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _processPayment,
        icon: const Icon(Icons.payment),
        label: Text(
          'Pay \$${cart.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    if (_selectedPaymentMethod == 'credit_card' &&
        (_formKey.currentState == null || !_formKey.currentState!.validate())) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
    });

    // Show success and navigate to confirmation
    _showPaymentSuccessDialog();
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your order has been placed successfully.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Create order and navigate to order history
                    final cartProvider = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );
                    final orderProvider = Provider.of<OrderProvider>(
                      context,
                      listen: false,
                    );
                    final notificationProvider =
                        Provider.of<NotificationProvider>(
                          context,
                          listen: false,
                        );

                    // Create order from cart items
                    final order = await orderProvider.createOrder(
                      cartItems: cartProvider.items,
                      totalAmount: cartProvider.totalAmount,
                      paymentMethod: _selectedPaymentMethod,
                    );

                    // Send payment success notification
                    await notificationProvider.sendPaymentNotification(
                      orderId: order.id,
                      amount: cartProvider.totalAmount,
                      paymentMethod: _selectedPaymentMethod,
                      isSuccess: true,
                    );

                    // Send order confirmation notification
                    await notificationProvider.sendOrderNotification(
                      orderId: order.id,
                      status: 'pending',
                    );

                    // Clear cart
                    cartProvider.clearCart();

                    // Navigate to order history
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const OrderHistoryScreen(),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text('View Order History'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: Text('$feature will be available in a future update!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
