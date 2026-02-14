import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../domain/entities/message.dart';
import '../../../../domain/entities/message_attachment.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.76,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            gradient: isUser ? AppPalette.userBubbleGradient : null,
            color: isUser ? null : AppPalette.surfaceSoft,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (message.attachment != null) _AttachmentView(message: message),
              if (message.content.trim().isNotEmpty)
                Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isUser ? Colors.white : AppPalette.textStrong,
                      ),
                ),
              const SizedBox(height: 4),
              Text(
                _formatTime(message.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppPalette.textMuted,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _AttachmentView extends StatelessWidget {
  const _AttachmentView({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachment!;
    if (attachment.type == AttachmentType.image) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            attachment.bytes,
            width: 220,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
