import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductSearchWidget extends StatefulWidget {
  final List<Product> products;
  final Function(List<Product>) onResults;

  const ProductSearchWidget({
    super.key,
    required this.products,
    required this.onResults,
  });

  @override
  State<ProductSearchWidget> createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  String _sortBy = 'name';
  double _minPrice = 0;
  double _maxPrice = 1000;

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
    _maxPrice = widget.products.isNotEmpty
        ? widget.products.map((p) => p.price).reduce((a, b) => a > b ? a : b)
        : 1000;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    String query = _searchController.text.toLowerCase();
    List<Product> results = widget.products.where((product) {
      bool matchesSearch =
          query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      bool matchesPrice =
          product.price >= _minPrice && product.price <= _maxPrice;

      return matchesSearch && matchesPrice;
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'price_low':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
      default:
        results.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    setState(() {
      _filteredProducts = results;
    });

    widget.onResults(results);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) => _performSearch(),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () => _showFilterDialog(),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[700]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          const SizedBox(height: 12),

          // Quick Filters
          Row(
            children: [
              Expanded(
                child: _buildQuickFilter('All', () {
                  _minPrice = 0;
                  _maxPrice = widget.products
                      .map((p) => p.price)
                      .reduce((a, b) => a > b ? a : b);
                  _performSearch();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickFilter('Under \$50', () {
                  _minPrice = 0;
                  _maxPrice = 50;
                  _performSearch();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickFilter('\$50-\$100', () {
                  _minPrice = 50;
                  _maxPrice = 100;
                  _performSearch();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickFilter('Above \$100', () {
                  _minPrice = 100;
                  _maxPrice = widget.products
                      .map((p) => p.price)
                      .reduce((a, b) => a > b ? a : b);
                  _performSearch();
                }),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sort Options
          Row(
            children: [
              const Text(
                'Sort by: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: _sortBy,
                  isExpanded: true,
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name A-Z')),
                    DropdownMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                      });
                      _performSearch();
                    }
                  },
                ),
              ),
              Text(
                '${_filteredProducts.length} results',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilter(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Filter Products'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Min Price',
                            prefixText: '\$',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _minPrice = double.tryParse(value) ?? 0;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Max Price',
                            prefixText: '\$',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _maxPrice = double.tryParse(value) ?? 1000;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: widget.products.isNotEmpty
                        ? widget.products
                              .map((p) => p.price)
                              .reduce((a, b) => a > b ? a : b)
                        : 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${_minPrice.round()}',
                      '\$${_maxPrice.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setStateDialog(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _performSearch();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
