import 'package:flutter/material.dart';

import '../../../../domain/entities/conversation.dart';
import 'conversation_card.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onActions,
  });

  final List<Conversation> items;
  final ValueChanged<Conversation> onOpen;
  final ValueChanged<Conversation> onActions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final conversation = items[index];
        return ConversationCard(
          conversation: conversation,
          onOpen: () => onOpen(conversation),
          onActions: () => onActions(conversation),
        );
      },
    );
  }
}
