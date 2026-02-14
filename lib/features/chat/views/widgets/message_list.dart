import 'package:flutter/material.dart';

import '../../../../domain/entities/message.dart';
import 'chat_empty_state.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.onPromptTap,
  });

  final List<Message> messages;
  final ValueChanged<String> onPromptTap;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return ChatEmptyState(onPromptTap: onPromptTap);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return MessageBubble(message: message);
      },
    );
  }
}
