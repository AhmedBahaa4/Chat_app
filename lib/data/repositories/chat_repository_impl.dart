import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../clients/ai_client.dart';
import '../local/conversation_store.dart';

class ChatRepositoryImpl implements ChatRepository {
  static const _defaultConversationTitle = 'New conversation';

  ChatRepositoryImpl({
    required AiClient aiClient,
    required ConversationStore conversationStore,
  })  : _aiClient = aiClient,
        _conversationStore = conversationStore;

  final AiClient _aiClient;
  final ConversationStore _conversationStore;

  @override
  Future<Conversation> createConversation({
    String? title,
    String? systemPrompt,
  }) async {
    final conversation = Conversation(
      id: _createConversationId(),
      title: _resolveTitle(title),
      updatedAt: DateTime.now(),
      systemPrompt: systemPrompt,
    );
    await _conversationStore.saveConversation(conversation);
    return conversation;
  }

  @override
  Future<List<Conversation>> getConversations() {
    return _conversationStore.getConversations();
  }

  @override
  Future<List<Message>> getMessages(String conversationId) {
    return _conversationStore.getMessages(conversationId);
  }

  @override
  Stream<Message> sendMessage({
    required String conversationId,
    required List<Message> history,
    required Message userMessage,
  }) async* {
    await _conversationStore.appendMessage(conversationId, userMessage);
    final stream = _aiClient.streamChatCompletion(
      history: history,
      userMessage: userMessage,
    );
    await for (final assistantMessage in stream) {
      await _conversationStore.upsertMessage(conversationId, assistantMessage);
      yield assistantMessage;
    }
  }

  @override
  Future<void> appendMessage({
    required String conversationId,
    required Message message,
  }) {
    return _conversationStore.appendMessage(conversationId, message);
  }

  @override
  Future<void> deleteConversation(String conversationId) {
    return _conversationStore.deleteConversation(conversationId);
  }

  @override
  Future<Conversation> updateConversationTitle({
    required String conversationId,
    required String title,
  }) async {
    final updated = await _conversationStore.updateConversationTitle(
      conversationId: conversationId,
      title: title,
    );
    if (updated == null) {
      throw StateError('Conversation not found');
    }
    return updated;
  }

  String _resolveTitle(String? title) {
    final trimmed = title?.trim();
    if (trimmed == null || trimmed.isEmpty) return _defaultConversationTitle;
    return trimmed;
  }

  String _createConversationId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
