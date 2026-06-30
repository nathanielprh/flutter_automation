import 'package:flutter_automation/features/chat/data/models/conversation_model.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl({required this.remote});

  @override
  Future<
    (
      ChatMessageEntity userMessage,
      ChatMessageEntity assistantMessage,
      ConversationEntity conversation,
    )
  >
  sendMessage({int? conversationId, required String message}) async {
    final res = await remote.sendMessage(
      conversationId: conversationId,
      message: message,
    );

    //final ChatMessageEntity reply = ChatMessageModel.fromJson(res['response']);
    final ConversationEntity conversation = ConversationModel.fromJson(
      res['conversation'],
    );

    final ChatMessageEntity userMessage = ChatMessageModel.fromJson(
      res['user_message'],
    );
    final ChatMessageEntity assistantMessage = ChatMessageModel.fromJson(
      res['assistant_message'],
    );

    print("\n\n\n user message(repository): ${userMessage.content}\n");
    print("AI response(repository): ${assistantMessage.content}\n\n\n");

    return (userMessage, assistantMessage, conversation);
  }

  @override
  Future<List<ConversationEntity>> getConversations() {
    return remote.getConversations();
  }

  @override
  Future<List<ChatMessageEntity>> getMessages(int conversationId) {
    return remote.getMessages(conversationId);
  }
}
