// Represents a single message in a conversation
// This is PURE logic layer (no JSON, no API)

class ChatMessageEntity {
  final int? id;
  final int? conversationId;
  final String role; // "user" or "assistant"
  final String content;
  final DateTime? createdAt;

  ChatMessageEntity({
    this.id,
    this.conversationId,
    required this.role,
    required this.content,
    this.createdAt,
  });
}
