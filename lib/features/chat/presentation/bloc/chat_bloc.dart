import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message_entity.dart';

import '../../domain/repositories/chat_repository.dart';

import 'chat_event.dart';

import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc({required this.repository}) : super(ChatState.initial()) {
    // Register event handler
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,

    Emitter<ChatState> emit,
  ) async {
    // Ignore empty messages
    if (event.message.trim().isEmpty) {
      return;
    }

    // Current messages
    final currentMessages = List<ChatMessageEntity>.from(state.messages);

    // Add user message immediately
    currentMessages.add(
      ChatMessageEntity(message: event.message, isUser: true),
    );

    // Emit loading state
    emit(state.copyWith(messages: currentMessages, isLoading: true));

    try {
      // Send to backend
      final aiReply = await repository.sendMessage(event.message);

      // Add AI response
      currentMessages.add(aiReply);

      emit(state.copyWith(messages: currentMessages, isLoading: false));
    } catch (e) {
      // Add error message
      currentMessages.add(
        ChatMessageEntity(message: e.toString(), isUser: false),
      );

      emit(
        state.copyWith(
          messages: currentMessages,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }
}
