import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),

        padding: const EdgeInsets.all(14),

        constraints: const BoxConstraints(maxWidth: 300),

        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade300,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Text(
          message,

          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
