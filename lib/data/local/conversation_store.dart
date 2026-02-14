import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import 'conversation_store_codec.dart';

class ConversationStore {
  ConversationStore({ConversationStoreCodec? codec}) : _codec = codec ?? const ConversationStoreCodec();

  static const String _boxName = 'chat_store';
  static const String _conversationsKey = 'conversations';
  static const String _messagesKey = 'messages';

  final ConversationStoreCodec _codec;
  final Map<String, List<Message>> _messages = {};
  final Map<String, Conversation> _conversations = {};
  bool _isLoaded = false;

  static Future<void> initializePersistence() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
  }

  Future<void> saveConversation(Conversation conversation) async {
    await _ensureLoaded();
    _conversations[conversation.id] = conversation;
    await _persist();
  }

  Future<void> deleteConversation(String conversationId) async {
    await _ensureLoaded();
    _conversations.remove(conversationId);
    _messages.remove(conversationId);
    await _persist();
  }

  Future<Conversation?> updateConversationTitle({
    required String conversationId,
    required String title,
  }) async {
    await _ensureLoaded();
    final current = _conversations[conversationId];
    if (current == null) return null;
    final updated = current.copyWith(
      title: title,
      updatedAt: DateTime.now(),
    );
    _conversations[conversationId] = updated;
    await _persist();
    return updated;
  }

  Future<List<Conversation>> getConversations() async {
    await _ensureLoaded();
    final conversations = _conversations.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return conversations;
  }

  Future<void> appendMessage(String conversationId, Message message) async {
    await _ensureLoaded();
    final messages = _messages.putIfAbsent(conversationId, () => <Message>[]);
    messages.add(message);
    _refreshConversationTimestamp(
      conversationId: conversationId,
      timestamp: message.createdAt,
    );
    await _persist();
  }

  Future<void> upsertMessage(String conversationId, Message message) async {
    await _ensureLoaded();
    final messages = _messages.putIfAbsent(conversationId, () => <Message>[]);
    final index = messages.indexWhere(
      (item) => item.id == message.id && item.role == message.role,
    );
    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }
    _refreshConversationTimestamp(
      conversationId: conversationId,
      timestamp: message.createdAt,
    );
    await _persist();
  }

  Future<List<Message>> getMessages(String conversationId) async {
    await _ensureLoaded();
    return List<Message>.unmodifiable(_messages[conversationId] ?? []);
  }

  void _refreshConversationTimestamp({
    required String conversationId,
    required DateTime timestamp,
  }) {
    final conversation = _conversations[conversationId];
    if (conversation == null) return;
    _conversations[conversationId] = conversation.copyWith(updatedAt: timestamp);
  }

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    _isLoaded = true;

    if (!Hive.isBoxOpen(_boxName)) return;
    final box = Hive.box<dynamic>(_boxName);
    final conversationsRaw = box.get(_conversationsKey);
    final messagesRaw = box.get(_messagesKey);

    if (conversationsRaw is List) {
      for (final item in conversationsRaw) {
        if (item is! Map<dynamic, dynamic>) continue;
        final conversation = _codec.decodeConversation(item);
        _conversations[conversation.id] = conversation;
      }
    }

    if (messagesRaw is Map) {
      for (final entry in messagesRaw.entries) {
        final conversationId = entry.key.toString();
        final rawList = entry.value;
        if (rawList is! List) continue;

        final decoded = <Message>[];
        for (final rawMessage in rawList) {
          if (rawMessage is! Map<dynamic, dynamic>) continue;
          decoded.add(_codec.decodeMessage(rawMessage));
        }
        _messages[conversationId] = decoded;
      }
    }
  }

  Future<void> _persist() async {
    if (!Hive.isBoxOpen(_boxName)) return;
    final box = Hive.box<dynamic>(_boxName);

    final encodedConversations = _conversations.values
        .map(_codec.encodeConversation)
        .toList(growable: false);

    final encodedMessages = <String, List<Map<String, dynamic>>>{};
    _messages.forEach((conversationId, messages) {
      encodedMessages[conversationId] =
          messages.map(_codec.encodeMessage).toList(growable: false);
    });

    await box.put(_conversationsKey, encodedConversations);
    await box.put(_messagesKey, encodedMessages);
  }
}
