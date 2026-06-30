// Represents a chat session (conversation)

class ConversationEntity {
  final int id;
  final int user_id;
  final String title;
  final DateTime createdAt;

  ConversationEntity({
    required this.id,
    required this.user_id,
    required this.title,
    required this.createdAt,
  });
}
