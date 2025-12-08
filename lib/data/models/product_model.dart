class ProductModel {
  final int id;
  final String name;
  final String description;
  final double initialPrice;
  final double currentPrice;
  final DateTime openingDate;
  final DateTime closingDate;
  final int timerId;
  final int sellerId;
  final int? buyerId;
  final int productStateId;
  final int availabilityStateId;
  final int categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.initialPrice,
    required this.currentPrice,
    required this.openingDate,
    required this.closingDate,
    required this.timerId,
    required this.sellerId,
    this.buyerId,
    required this.productStateId,
    required this.availabilityStateId,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      initialPrice: (json["initialPrice"] ?? 0).toDouble(),
      currentPrice: (json["currentPrice"] ?? 0).toDouble(),
      openingDate: DateTime.parse(json["openingDate"]),
      closingDate: DateTime.parse(json["closingDate"]),
      timerId: json["timerId"],
      sellerId: json["sellerId"],
      buyerId: json["buyerId"],
      productStateId: json["productStateId"],
      availabilityStateId: json["availabilityStateId"],
      categoryId: json["categoryId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "initialPrice": initialPrice,
      "currentPrice": currentPrice,
      "openingDate": openingDate.toIso8601String(),
      "closingDate": closingDate.toIso8601String(),
      "timerId": timerId,
      "sellerId": sellerId,
      "buyerId": buyerId,
      "productStateId": productStateId,
      "availabilityStateId": availabilityStateId,
      "categoryId": categoryId,
    };
  }
}
