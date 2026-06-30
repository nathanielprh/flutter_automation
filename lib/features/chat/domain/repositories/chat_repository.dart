import '../entities/chat_message_entity.dart';
import '../entities/conversation_entity.dart';

abstract class ChatRepository {
  // Send message (creates conversation if null)
  Future<
    (
      ChatMessageEntity userMessage,
      ChatMessageEntity assistantMessage,
      ConversationEntity conversation,
    )
  >
  sendMessage({int? conversationId, required String message});

  // Get all conversations
  Future<List<ConversationEntity>> getConversations();

  // Get messages inside a conversation
  Future<List<ChatMessageEntity>> getMessages(int conversationId);
}
