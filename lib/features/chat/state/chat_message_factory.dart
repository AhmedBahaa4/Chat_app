import '../../../domain/entities/message.dart';
import '../../../domain/entities/message_attachment.dart';

class ChatMessageFactory {
  const ChatMessageFactory();

  static const String defaultImagePrompt = 'Describe this image';
  static const String connectionErrorMessage =
      'Connection failed. Check GEMINI_API_KEY and internet access.';

  Message? createUserMessage(String text, MessageAttachment? attachment) {
    final trimmed = text.trim();
    if (trimmed.isEmpty && attachment == null) return null;

    final now = DateTime.now();
    return Message(
      id: now.microsecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: trimmed.isEmpty ? defaultImagePrompt : trimmed,
      createdAt: now,
      status: MessageStatus.pending,
      attachment: attachment,
    );
  }

  Message createAssistantErrorMessage({String? details}) {
    final now = DateTime.now();
    final errorText = _resolveErrorText(details);
    return Message(
      id: now.microsecondsSinceEpoch.toString(),
      role: MessageRole.assistant,
      content: errorText,
      createdAt: now,
      status: MessageStatus.failed,
    );
  }

  String _resolveErrorText(String? details) {
    final normalized = details?.trim();
    if (normalized == null || normalized.isEmpty) return connectionErrorMessage;
    return normalized;
  }
}
