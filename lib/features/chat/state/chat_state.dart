import '../../../domain/entities/message.dart';

class ChatState {
  const ChatState({
    this.messages = const [],
    this.isSending = false,
  });

  final List<Message> messages;
  final bool isSending;

  ChatState copyWith({
    List<Message>? messages,
    bool? isSending,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  static ChatState initial() => const ChatState();
}
