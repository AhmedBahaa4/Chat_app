import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_palette.dart';
import '../state/chat_controller.dart';

import 'widgets/chat_content.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key, required this.conversationId, required this.title});

  final String conversationId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatAsync = ref.watch(chatControllerProvider(conversationId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              'AI assistant',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 18),
            decoration: const BoxDecoration(
              color: AppPalette.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      body: ChatContent(
        chatAsync: chatAsync,
        onSend: (text, attachment) => ref
            .read(chatControllerProvider(conversationId).notifier)
            .sendUserMessage(
              conversationId,
              text,
              attachment: attachment,
            ),
      ),
    );
  }
}
