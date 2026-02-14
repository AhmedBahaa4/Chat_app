import 'package:equatable/equatable.dart';

import 'message_attachment.dart';

enum MessageRole { user, assistant, system }

class Message extends Equatable {
  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.status = MessageStatus.delivered,
    this.attachment,
  });

  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  final MessageStatus status;
  final MessageAttachment? attachment;

  Message copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? createdAt,
    MessageStatus? status,
    MessageAttachment? attachment,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      attachment: attachment ?? this.attachment,
    );
  }

  @override
  List<Object?> get props =>
      [id, role, content, createdAt, status, attachment];
}

enum MessageStatus { pending, delivered, failed }
