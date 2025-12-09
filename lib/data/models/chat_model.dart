class ChatModel {
  final int id;
  final int sellerId;
  final int buyerId;

  ChatModel({
    required this.id,
    required this.sellerId,
    required this.buyerId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      sellerId: json['sellerId'],
      buyerId: json['buyerId'],
    );
  }
}
