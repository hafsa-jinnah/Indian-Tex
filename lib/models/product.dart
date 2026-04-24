class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.category,
    required this.description,
    required this.imageUrl,
    this.imageUrls,
    required this.clothType,
    required this.colors,
    required this.sizes,
    required this.rating,
  });

  final String id;
  final String name;
  final double price;
  final double discountedPrice;
  final String category;
  final String description;
  final String imageUrl;
  final List<String>? imageUrls;
  final String clothType;
  final List<String> colors;
  final List<String> sizes;
  final double rating;

  List<String> get allImages => (imageUrls == null || imageUrls!.isEmpty)
      ? [imageUrl]
      : List.unmodifiable(imageUrls!);
}
