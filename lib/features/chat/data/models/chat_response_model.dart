class ChatResponseModel {
  final String reply;

  ChatResponseModel({required this.reply});

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(reply: json["reply"]);
  }
}
