import 'package:flutter/material.dart';

class ChatInputRow extends StatelessWidget {
  const ChatInputRow({
    super.key,
    required this.controller,
    required this.onPickImage,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onPickImage;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onPickImage,
          icon: const Icon(Icons.image_outlined),
          tooltip: 'Attach image',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 4,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSend(),
            decoration: const InputDecoration(
              hintText: 'Ask anything...',
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: onSend,
          icon: const Icon(Icons.arrow_upward_rounded),
          tooltip: 'Send',
        ),
      ],
    );
  }
}
