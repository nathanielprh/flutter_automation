import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ConversationListView extends StatelessWidget {
  const ConversationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button to spin up a completely brand new chat window
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              // Purely dispatching an event to the BLoC now!
              context.read<ChatBloc>().add(ResetChatEvent());

              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('New Chat'),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state.conversations.isEmpty && state.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.conversations.isEmpty) {
                return const Center(
                  child: Text(
                    'No chat history yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];
                  final isSelected = state.conversationId == conversation.id;

                  return ListTile(
                    leading: const Icon(Icons.chat_bubble_outline),
                    title: Text(
                      conversation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    selected: isSelected,
                    selectedTileColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.3),
                    onTap: () {
                      context.read<ChatBloc>().add(
                        LoadMessagesEvent(conversation.id),
                      );

                      // Close drawer automatically if viewing on mobile layouts
                      if (Scaffold.of(context).isDrawerOpen) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
