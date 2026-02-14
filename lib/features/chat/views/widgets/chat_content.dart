import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../domain/entities/message_attachment.dart';
import '../../state/chat_state.dart';
import 'chat_composer.dart';
import 'message_list.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({
    super.key,
    required this.chatAsync,
    required this.onSend,
  });

  final AsyncValue<ChatState> chatAsync;
  final Future<void> Function(String text, MessageAttachment? attachment) onSend;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppPalette.homeBackgroundGradient,
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: chatAsync.when(
                data: (state) => MessageList(
                  messages: state.messages,
                  onPromptTap: (prompt) => onSend(prompt, null),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, __) => Center(child: Text('Something went wrong: $e')),
              ),
            ),
            ChatComposer(onSend: onSend),
          ],
        ),
      ],
    );
  }
}
