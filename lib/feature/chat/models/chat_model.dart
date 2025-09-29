class ChatModel {
  final String id;
  final String message;
  final String role;

  ChatModel({required this.id, required this.message, required this.role});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'message': message, 'role': role};
  }
}
