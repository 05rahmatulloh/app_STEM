class ChatModel {
  final String id;
  final String message;

  ChatModel({required this.id, required this.message});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(id: json['id'], message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'message': message};
  }
}
