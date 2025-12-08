class BidModel {
  final int id;
  final int productId;
  final int userId;
  final int proposedPrice;
  final DateTime proposedAt;

  BidModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.proposedPrice,
    required this.proposedAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] is int
          ? json['id']
          : int.parse(json['id'].toString()),

      productId: json['productId'] is int
          ? json['productId']
          : int.parse(json['productId'].toString()),

      userId: json['userId'] is int
          ? json['userId']
          : int.parse(json['userId'].toString()),

      proposedPrice: json['proposedPrice'] is int
          ? json['proposedPrice']
          : int.parse(json['proposedPrice'].toString()),

      proposedAt: DateTime.parse(json['proposedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'proposedPrice': proposedPrice,
      'proposedAt': proposedAt.toIso8601String(),
    };
  }
}
