class ProductModel {
  final int id;
  final String name;
  final String description;
  final double initialPrice;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.initialPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      initialPrice: (json['initialPrice'] as num).toDouble(),
    );
  }
}
