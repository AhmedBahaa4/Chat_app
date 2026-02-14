import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../domain/entities/conversation.dart';
import '../../../../domain/entities/message.dart';
import '../../../chat/providers.dart';
import '../../../chat/views/chat_page.dart';
import '../../state/conversations_controller.dart';
import '../widgets/conversation_actions_sheet.dart';

class HomeConversationActions {
  const HomeConversationActions({
    required BuildContext context,
    required WidgetRef ref,
  })  : _context = context,
        _ref = ref;

  final BuildContext _context;
  final WidgetRef _ref;

  Future<void> createConversation() async {
    final created = await _ref
        .read(conversationsControllerProvider.notifier)
        .createConversation();
    if (!_context.mounted) return;
    openConversation(created);
  }

  Future<void> handleActions(Conversation conversation) async {
    final action = await showConversationActionsSheet(_context);
    if (!_context.mounted || action == null) return;

    switch (action) {
      case ConversationAction.rename:
        await _renameConversation(conversation);
        return;
      case ConversationAction.share:
        await _shareConversation(conversation);
        return;
      case ConversationAction.delete:
        await _deleteConversation(conversation);
        return;
    }
  }

  void openConversation(Conversation conversation) {
    Navigator.of(_context).push(
      MaterialPageRoute(
        builder: (_) => ChatPage(
          conversationId: conversation.id,
          title: conversation.title,
        ),
      ),
    );
  }

  Future<void> _renameConversation(Conversation conversation) async {
    final title = await showRenameDialog(
      _context,
      initial: conversation.title,
    );
    if (!_context.mounted || title == null) return;

    await _ref
        .read(conversationsControllerProvider.notifier)
        .renameConversation(conversation.id, title);
  }

  Future<void> _shareConversation(Conversation conversation) async {
    final text = await _buildShareText(conversation);
    if (!_context.mounted) return;
    await Share.share(text, subject: conversation.title);
  }

  Future<void> _deleteConversation(Conversation conversation) async {
    final confirmed = await showDeleteConfirmDialog(_context);
    if (!_context.mounted || !confirmed) return;

    await _ref
        .read(conversationsControllerProvider.notifier)
        .deleteConversation(conversation.id);
  }

  Future<String> _buildShareText(Conversation conversation) async {
    final repo = _ref.read(chatRepositoryProvider);
    final messages = await repo.getMessages(conversation.id);
    if (messages.isEmpty) return conversation.title;

    final buffer = StringBuffer('${conversation.title}\n\n');
    for (final message in messages) {
      buffer.writeln('${_roleLabel(message.role)}: ${message.content}');
    }
    return buffer.toString();
  }

  String _roleLabel(MessageRole role) {
    switch (role) {
      case MessageRole.user:
        return 'You';
      case MessageRole.assistant:
        return 'Assistant';
      case MessageRole.system:
        return 'System';
    }
  }
}
