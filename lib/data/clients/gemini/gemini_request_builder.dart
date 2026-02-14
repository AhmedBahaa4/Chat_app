import 'dart:convert';

import '../../../../core/config/app_config.dart';
import '../../../../domain/entities/message.dart';
import '../../../../domain/entities/message_attachment.dart';

class GeminiRequestBuilder {
  const GeminiRequestBuilder();

  String buildUrl(String model) {
    return '${AppConfig.geminiBaseUrl}/models/$model:streamGenerateContent?alt=sse';
  }

  String buildPayload({
    required List<Message> history,
    required Message userMessage,
  }) {
    final payload = {
      'contents': _buildContents(history, userMessage),
    };
    return jsonEncode(payload);
  }

  Map<String, String> buildHeaders({
    required String apiKey,
    Map<String, String>? extraHeaders,
  }) {
    return {
      'x-goog-api-key': apiKey,
      'Content-Type': 'application/json',
      if (extraHeaders != null) ...extraHeaders,
    };
  }

  List<Map<String, dynamic>> _buildContents(
    List<Message> history,
    Message userMessage,
  ) {
    final items = [...history, userMessage]
        .where((message) => message.role != MessageRole.system)
        .toList();

    return items.map((message) {
      return {
        'role': message.role == MessageRole.assistant ? 'model' : 'user',
        'parts': _buildParts(message),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _buildParts(Message message) {
    final parts = <Map<String, dynamic>>[];
    final text = message.content.trim();
    if (text.isNotEmpty) {
      parts.add({'text': text});
    }

    final attachment = message.attachment;
    if (attachment != null && attachment.type == AttachmentType.image) {
      parts.add({
        'inline_data': {
          'mime_type': attachment.mimeType,
          'data': base64Encode(attachment.bytes),
        },
      });
    }

    return parts;
  }
}
