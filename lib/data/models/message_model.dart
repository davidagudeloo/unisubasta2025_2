class MessageModel {
  final int id;
  final String message;
  final DateTime dateTime;
  final int emitterId;
  final int chatId;

  MessageModel({
    required this.id,
    required this.message,
    required this.dateTime,
    required this.emitterId,
    required this.chatId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      message: json["message"],
      dateTime: DateTime.parse(json["dateTime"]),
      emitterId: json["emitterId"],
      chatId: json["chatId"],
    );
  }
}
