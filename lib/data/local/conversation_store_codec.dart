import 'dart:convert';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_attachment.dart';

class ConversationStoreCodec {
  const ConversationStoreCodec();

  Map<String, dynamic> encodeConversation(Conversation conversation) {
    return {
      'id': conversation.id,
      'title': conversation.title,
      'updatedAt': conversation.updatedAt.toIso8601String(),
      'systemPrompt': conversation.systemPrompt,
    };
  }

  Conversation decodeConversation(Map<dynamic, dynamic> raw) {
    return Conversation(
      id: raw['id'] as String,
      title: raw['title'] as String,
      updatedAt: DateTime.parse(raw['updatedAt'] as String),
      systemPrompt: raw['systemPrompt'] as String?,
    );
  }

  Map<String, dynamic> encodeMessage(Message message) {
    return {
      'id': message.id,
      'role': message.role.name,
      'content': message.content,
      'createdAt': message.createdAt.toIso8601String(),
      'status': message.status.name,
      'attachment': _encodeAttachment(message.attachment),
    };
  }

  Message decodeMessage(Map<dynamic, dynamic> raw) {
    return Message(
      id: raw['id'] as String,
      role: _parseRole(raw['role'] as String?),
      content: raw['content'] as String? ?? '',
      createdAt: DateTime.parse(raw['createdAt'] as String),
      status: _parseStatus(raw['status'] as String?),
      attachment: _decodeAttachment(raw['attachment']),
    );
  }

  Map<String, dynamic>? _encodeAttachment(MessageAttachment? attachment) {
    if (attachment == null) return null;
    return {
      'type': attachment.type.name,
      'bytes': base64Encode(attachment.bytes),
      'mimeType': attachment.mimeType,
      'name': attachment.name,
    };
  }

  MessageAttachment? _decodeAttachment(dynamic raw) {
    if (raw is! Map<dynamic, dynamic>) return null;
    final bytesRaw = raw['bytes'] as String?;
    if (bytesRaw == null || bytesRaw.isEmpty) return null;

    return MessageAttachment(
      type: _parseAttachmentType(raw['type'] as String?),
      bytes: base64Decode(bytesRaw),
      mimeType: raw['mimeType'] as String? ?? 'application/octet-stream',
      name: raw['name'] as String?,
    );
  }

  MessageRole _parseRole(String? raw) {
    return MessageRole.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => MessageRole.user,
    );
  }

  MessageStatus _parseStatus(String? raw) {
    return MessageStatus.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => MessageStatus.delivered,
    );
  }

  AttachmentType _parseAttachmentType(String? raw) {
    return AttachmentType.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => AttachmentType.image,
    );
  }
}
