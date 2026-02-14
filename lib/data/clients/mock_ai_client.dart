import 'dart:async';

import '../../domain/entities/message.dart';
import 'ai_client.dart';

class MockAiClient implements AiClient {
  @override
  Stream<Message> streamChatCompletion({
    required List<Message> history,
    required Message userMessage,
    Map<String, String>? extraHeaders,
  }) async* {
    final response = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: MessageRole.assistant,
      content: _generateReply(userMessage.content),
      createdAt: DateTime.now(),
      status: MessageStatus.delivered,
    );

    // Simulate streaming by yielding chunks.
    final text = response.content;
    final chunkSize = (text.length / 3).ceil();
    for (var i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, text.length);
      yield response.copyWith(content: text.substring(0, end));
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
  }

  String _generateReply(String prompt) {
    if (prompt.trim().isEmpty) {
      return 'Hello! How can I help you today?';
    }
    return 'Quick summary of your message: "$prompt". This is a mock reply.';
  }
}
