import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../widgets/conversation_list_view.dart';
import '../widgets/message_history_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the list of historical chats as soon as the screen opens
    context.read<ChatBloc>().add(LoadConversationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        elevation: 1,
        // Only show drawer button if we are on a narrow/mobile layout
        leading: isWideScreen
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
      ),
      // Drawer layout for mobile devices
      drawer: isWideScreen
          ? null
          : const Drawer(child: SafeArea(child: ConversationListView())),
      body: Row(
        children: [
          // Persistent Sidebar layout for Desktop/Web/Tablets
          if (isWideScreen)
            const SizedBox(
              width: 300,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.black12)),
                ),
                child: ConversationListView(),
              ),
            ),
          // Chat viewport takes the rest of the available space
          const Expanded(child: MessageHistoryView()),
        ],
      ),
    );
  }
}
