import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/conversation.dart';
import '../../chat/providers.dart';

final conversationsControllerProvider = AutoDisposeAsyncNotifierProvider<
    ConversationsController, List<Conversation>>(ConversationsController.new);

class ConversationsController
    extends AutoDisposeAsyncNotifier<List<Conversation>> {
  @override
  FutureOr<List<Conversation>> build() async {
    final repo = ref.read(chatRepositoryProvider);
    final items = await repo.getConversations();
    if (items.isNotEmpty) return items;
    final created = await repo.createConversation(title: 'Chat with AI');
    return [created];
  }

  Future<Conversation> createConversation() async {
    final repo = ref.read(chatRepositoryProvider);
    final created = await repo.createConversation();
    await _reload();
    return created;
  }

  Future<void> renameConversation(String id, String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final repo = ref.read(chatRepositoryProvider);
    await repo.updateConversationTitle(
      conversationId: id,
      title: trimmed,
    );
    await _reload();
  }

  Future<void> deleteConversation(String id) async {
    final repo = ref.read(chatRepositoryProvider);
    await repo.deleteConversation(id);
    await _reload();
  }

  Future<void> _reload() async {
    final repo = ref.read(chatRepositoryProvider);
    final items = await repo.getConversations();
    state = AsyncData(items);
  }
}
