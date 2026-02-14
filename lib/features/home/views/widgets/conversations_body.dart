import 'package:flutter/material.dart';

import '../../../../domain/entities/conversation.dart';
import 'conversation_list.dart';
import 'home_background.dart';
import 'home_empty_state.dart';

class ConversationsBody extends StatelessWidget {
  const ConversationsBody({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onActions,
    required this.onCreateConversation,
  });

  final List<Conversation> items;
  final ValueChanged<Conversation> onOpen;
  final ValueChanged<Conversation> onActions;
  final VoidCallback onCreateConversation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: HomeBackground()),
        if (items.isEmpty)
          HomeEmptyState(onCreateConversation: onCreateConversation)
        else
          ConversationList(
            items: items,
            onOpen: onOpen,
            onActions: onActions,
          ),
      ],
    );
  }
}
