abstract class ChatEvent {}

// Event to send a message in a new or existing conversation
class SendMessageEvent extends ChatEvent {
  final String message;
  final int? conversationId;

  SendMessageEvent({required this.message, this.conversationId});
}

// Event to load messages inside a specific active conversation
class LoadMessagesEvent extends ChatEvent {
  final int conversationId;

  LoadMessagesEvent(this.conversationId);
}

// Event to fetch the sidebar/list of all past conversations
class LoadConversationsEvent extends ChatEvent {
  LoadConversationsEvent();
}

// Event to clear active conversation history and start fresh
class ResetChatEvent extends ChatEvent {
  ResetChatEvent();
}
