import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.conversationId,
    required super.role,
    required super.content,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      role: json['role'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
