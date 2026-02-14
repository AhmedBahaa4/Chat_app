import '../../domain/entities/message.dart';

abstract class AiClient {
  /// Streams assistant messages for a given prompt + history.
  Stream<Message> streamChatCompletion({
    required List<Message> history,
    required Message userMessage,
    Map<String, String>? extraHeaders,
  });
}
