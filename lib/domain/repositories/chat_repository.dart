import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<List<Conversation>> getConversations();
  Future<List<Message>> getMessages(String conversationId);
  Stream<Message> sendMessage({
    required String conversationId,
    required List<Message> history,
    required Message userMessage,
  });
  Future<void> appendMessage({
    required String conversationId,
    required Message message,
  });
  Future<Conversation> createConversation({String? title, String? systemPrompt});
  Future<void> deleteConversation(String conversationId);
  Future<Conversation> updateConversationTitle({
    required String conversationId,
    required String title,
  });
}
