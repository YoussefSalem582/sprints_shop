class Product {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}

class HotOffer {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String originalPrice;
  final String discountedPrice;

  HotOffer({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
  });
}
