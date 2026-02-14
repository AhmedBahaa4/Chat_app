import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../data/clients/ai_client.dart';
import '../../data/clients/gemini_ai_client.dart';
import '../../data/clients/mock_ai_client.dart';
import '../../data/local/conversation_store.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';

final aiClientProvider = Provider<AiClient>((ref) {
  if (AppConfig.useMockAi) return MockAiClient();
  return GeminiAiClient();
});

final conversationStoreProvider = Provider<ConversationStore>(
  (ref) => ConversationStore(),
);

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    aiClient: ref.read(aiClientProvider),
    conversationStore: ref.read(conversationStoreProvider),
  );
});
