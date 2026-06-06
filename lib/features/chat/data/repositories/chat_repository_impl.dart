import '../../domain/entities/chat_message_entity.dart';

import '../../domain/repositories/chat_repository.dart';

import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ChatMessageEntity> sendMessage(String message) async {
    // Call backend
    final response = await remoteDatasource.sendMessage(message);

    // Convert response into entity
    return ChatMessageEntity(message: response.reply, isUser: false);
  }
}
