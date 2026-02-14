class AppConfig {
  static const String geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY');

  static const String geminiModel =
      String.fromEnvironment(
        'GEMINI_MODEL',
        defaultValue: 'gemini-2.0-flash',
      );

  static const bool useMockAi =
      bool.fromEnvironment(
        'USE_MOCK_AI',
        defaultValue: false,
      );

  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
}
