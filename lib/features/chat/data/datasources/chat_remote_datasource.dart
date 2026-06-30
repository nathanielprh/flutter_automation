import '../../../../core/network/dio_client.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ChatRemoteDataSource {
  final DioClient dioClient;

  ChatRemoteDataSource({required this.dioClient});

  // Send message to backend
  Future<Map<String, dynamic>> sendMessage({
    int? conversationId,
    required String message,
  }) async {
    final response = await dioClient.dio.post(
      '/chat',
      data: {"conversation_id": conversationId, "message": message},
    );
    print("AI response(datasource): ${response.data}");

    return response.data;
  }

  // Get all conversations
  Future<List<ConversationModel>> getConversations() async {
    // 1. See what headers (including your JWT Token) Dio is attaching
    print("Dio Request Options Headers: ${dioClient.dio.options.headers}");

    final response = await dioClient.dio.get('/chat/conversations');

    // 2. See the raw JSON payload coming back from FastAPI
    print("FastAPI Conversations Response Data: ${response.data}");

    return (response.data as List)
        .map((e) => ConversationModel.fromJson(e))
        .toList();
  }

  // Get messages
  Future<List<ChatMessageModel>> getMessages(int conversationId) async {
    final response = await dioClient.dio.get(
      '/chat/conversations/$conversationId/messages',
    );

    return (response.data as List)
        .map((e) => ChatMessageModel.fromJson(e))
        .toList();
  }
}
