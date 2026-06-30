import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';

class ChatState {
  final int? conversationId;
  final List<ChatMessageEntity> messages;
  final List<ConversationEntity>
  conversations; // Added to hold the list of conversations
  final bool loading;
  final String? error; // Added for error handling

  ChatState({
    this.conversationId,
    this.messages = const [],
    this.conversations = const [],
    this.loading = false,
    this.error,
  });

  ChatState copyWith({
    int? conversationId,
    List<ChatMessageEntity>? messages,
    List<ConversationEntity>? conversations,
    bool? loading,
    String? error,
  }) {
    return ChatState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
      loading: loading ?? this.loading,
      error:
          error, // Intentional override to clear error if not explicitly passed
    );
  }
}
