import 'package:flutter/material.dart';

enum ConversationAction { rename, share, delete }

Future<ConversationAction?> showConversationActionsSheet(BuildContext context) {
  return showModalBottomSheet<ConversationAction>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename conversation'),
              onTap: () => Navigator.pop(context, ConversationAction.rename),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share conversation'),
              onTap: () => Navigator.pop(context, ConversationAction.share),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete conversation',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.pop(context, ConversationAction.delete),
            ),
          ],
        ),
      );
    },
  );
}

Future<String?> showRenameDialog(
  BuildContext context, {
  required String initial,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Rename conversation'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter a new name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

Future<bool> showDeleteConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete conversation?'),
      content: const Text(
        'This action will remove the conversation from your local history.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}
