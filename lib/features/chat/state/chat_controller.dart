import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/message.dart';
import '../../../domain/entities/message_attachment.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../providers.dart';
import 'chat_message_factory.dart';
import 'chat_state.dart';

class ChatController extends AutoDisposeFamilyAsyncNotifier<ChatState, String> {
  late final ChatRepository _repo;
  final ChatMessageFactory _messageFactory = const ChatMessageFactory();

  @override
  FutureOr<ChatState> build(String conversationId) async {
    _repo = ref.read(chatRepositoryProvider);
    final messages = await _repo.getMessages(conversationId);
    return ChatState(messages: messages);
  }

  Future<void> sendUserMessage(
    String conversationId,
    String text, {
    MessageAttachment? attachment,
  }) async {
    final userMessage = _messageFactory.createUserMessage(text, attachment);
    if (userMessage == null) return;

    _appendUserMessage(userMessage);
    final history = state.value?.messages ?? const <Message>[];
    final stream = _repo.sendMessage(
      conversationId: conversationId,
      history: history,
      userMessage: userMessage,
    );

    try {
      var hasAssistantResponse = false;
      await for (final assistantMessage in stream) {
        hasAssistantResponse = true;
        _upsertAssistantMessage(assistantMessage);
      }
      if (!hasAssistantResponse) {
        await _appendAssistantEmptyResponse(conversationId: conversationId);
      }
      _setSending(false);
    } catch (error) {
      await _appendAssistantError(
        conversationId: conversationId,
        details: _normalizeErrorText(error),
      );
      _setSending(false);
    }
  }

  void _appendUserMessage(Message message) {
    final current = state.value ?? ChatState.initial();
    state = AsyncData(
      current.copyWith(
        messages: [...current.messages, message],
        isSending: true,
      ),
    );
  }

  void _upsertAssistantMessage(Message incoming) {
    final current = state.value ?? ChatState.initial();
    final index = current.messages.indexWhere(
      (message) =>
          message.id == incoming.id && message.role == MessageRole.assistant,
    );

    final updatedMessages = [...current.messages];
    if (index == -1) {
      updatedMessages.add(incoming);
    } else {
      updatedMessages[index] = incoming;
    }

    state = AsyncData(current.copyWith(messages: updatedMessages));
  }

  Future<void> _appendAssistantError({
    required String conversationId,
    required String details,
  }) async {
    final current = state.value ?? ChatState.initial();
    final errorMessage = _messageFactory.createAssistantErrorMessage(
      details: details,
    );
    await _repo.appendMessage(
      conversationId: conversationId,
      message: errorMessage,
    );
    state = AsyncData(
      current.copyWith(messages: [...current.messages, errorMessage]),
    );
  }

  Future<void> _appendAssistantEmptyResponse({
    required String conversationId,
  }) async {
    final current = state.value ?? ChatState.initial();
    final message = _messageFactory.createAssistantEmptyResponseMessage();
    await _repo.appendMessage(
      conversationId: conversationId,
      message: message,
    );
    state = AsyncData(
      current.copyWith(messages: [...current.messages, message]),
    );
  }

  void _setSending(bool isSending) {
    final current = state.value ?? ChatState.initial();
    state = AsyncData(current.copyWith(isSending: isSending));
  }

  String _normalizeErrorText(Object error) {
    final text = error.toString();
    return text.replaceFirst('AiClientException: ', '');
  }
}

final chatControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<ChatController, ChatState, String>(
  ChatController.new,
);
