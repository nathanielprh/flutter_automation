import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message_entity.dart';

class ChatState extends Equatable {
  final List<ChatMessageEntity> messages;

  final bool isLoading;

  final String? error;

  const ChatState({
    required this.messages,

    required this.isLoading,

    this.error,
  });

  // Initial state
  factory ChatState.initial() {
    return const ChatState(messages: [], isLoading: false);
  }

  // Copy state with updates
  ChatState copyWith({
    List<ChatMessageEntity>? messages,

    bool? isLoading,

    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,

      isLoading: isLoading ?? this.isLoading,

      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error];
}
