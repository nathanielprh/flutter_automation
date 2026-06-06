import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';

import '../models/chat_request_model.dart';
import '../models/chat_response_model.dart';

class ChatRemoteDatasource {
  final DioClient dioClient;

  ChatRemoteDatasource({required this.dioClient});

  Future<ChatResponseModel> sendMessage(String message) async {
    try {
      // Create request body
      final request = ChatRequestModel(message: message);

      // Send POST request
      final response = await dioClient.dio.post(
        "/chat",
        data: request.toJson(),
      );

      // Convert JSON to model
      return ChatResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data["detail"] ?? "Failed to send message");
    }
  }
}
