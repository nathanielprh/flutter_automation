class ChatMessageEntity {
  final String message;

  // true = user message
  // false = AI message
  final bool isUser;

  ChatMessageEntity({required this.message, required this.isUser});
}
