import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

import '../bloc/chat_event.dart';

import '../bloc/chat_state.dart';

import '../widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chat")),

      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),

                  itemCount: state.messages.length,

                  itemBuilder: (context, index) {
                    final message = state.messages[index];

                    return ChatBubble(
                      message: message.message,
                      isUser: message.isUser,
                    );
                  },
                );
              },
            ),
          ),

          // Loading indicator
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (!state.isLoading) {
                return const SizedBox();
              }

              return const Padding(
                padding: EdgeInsets.all(8),

                child: CircularProgressIndicator(),
              );
            },
          ),

          // Message input
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,

                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    onPressed: () {
                      final text = controller.text;

                      controller.clear();

                      // Send event to bloc
                      context.read<ChatBloc>().add(
                        SendMessageEvent(message: text),
                      );
                    },

                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
