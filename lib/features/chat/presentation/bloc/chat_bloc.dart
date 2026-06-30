import 'package:flutter_automation/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadConversationsEvent>(
      _onLoadConversations,
    ); // Registered the conversation list event
    on<ResetChatEvent>(_onResetChat);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    // 1. Create a temporary ChatMessageEntity for the user's message right now
    // (Adjust parameters based on your exact ChatMessageEntity constructor)
    final temporaryUserMessage = ChatMessageEntity(
      role: 'user',
      content: event.message,
      conversationId: state.conversationId ?? event.conversationId,
    );

    // 2. Instantly update the state list so the user sees their message text layout immediately
    final localUpdatedMessages = List.of(state.messages)
      ..add(temporaryUserMessage);

    emit(
      state.copyWith(
        messages: localUpdatedMessages,
        loading: true, // Turn on loading indicator *after* displaying the text
      ),
    );

    try {
      // 3. Fire off the network request to FastAPI in the background
      final result = await repository.sendMessage(
        conversationId: state.conversationId ?? event.conversationId,
        message: event.message,
      );

      final serverUserMessage = result.$1;
      final assistantMessage = result.$2;
      final currentConversation = result.$3;

      // 4. Build the final message list using the validated backend payload strings
      // We replace our local list with the source of truth from the server
      final finalMessages = List.of(state.messages)
        ..removeLast() // Remove our local temporary message
        ..addAll([
          serverUserMessage,
          assistantMessage,
        ]); // Add official backend responses

      final updatedConversations = List.of(state.conversations);
      final index = updatedConversations.indexWhere(
        (c) => c.id == currentConversation.id,
      );
      if (index == -1) {
        updatedConversations.insert(0, currentConversation);
      }

      emit(
        state.copyWith(
          conversationId: currentConversation.id,
          messages: finalMessages,
          conversations: updatedConversations,
          loading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final messages = await repository.getMessages(event.conversationId);

      emit(
        state.copyWith(
          conversationId: event.conversationId,
          messages: messages,
          loading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // 1. Fetching historical list on startup
  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final historicalList = await repository.getConversations();

      emit(
        state.copyWith(
          conversations: historicalList, // Save to state
          loading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // 2. Clear current chat view without breaking the sidebar list
  void _onResetChat(ResetChatEvent event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        messages: const [],
        conversationId: null,
        loading: false,
        // explicitly do NOT alter state.conversations here
      ),
    );
  }
}
