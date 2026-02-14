
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/conversations_controller.dart';
import 'helpers/home_conversation_actions.dart';
import 'widgets/conversations_body.dart';
import 'widgets/home_app_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsControllerProvider);
    final actions = HomeConversationActions(context: context, ref: ref);

    return Scaffold(
      appBar: HomeAppBar(onCreateConversation: actions.createConversation),
      body: conversations.when(
        data: (items) => ConversationsBody(
          items: items,
          onOpen: actions.openConversation,
          onActions: actions.handleActions,
          onCreateConversation: actions.createConversation,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
      ),
    );
  }
}
