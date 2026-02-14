import 'dart:convert';

class GeminiStreamParser {
  const GeminiStreamParser();

  static const String _dataPrefix = 'data:';
  static const String _doneSignal = '[DONE]';

  Stream<String> decodeSseLines(Stream<dynamic> stream) {
    return stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
  }

  bool isDoneLine(String line) {
    return _stripDataPrefix(line) == _doneSignal;
  }

  String extractTextFromLine(String line) {
    final payload = _stripDataPrefix(line);
    if (payload.isEmpty || payload == _doneSignal) return '';

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) return '';

      final candidates = decoded['candidates'];
      if (candidates is! List || candidates.isEmpty) return '';

      final firstCandidate = candidates.first;
      if (firstCandidate is! Map<String, dynamic>) return '';

      final content = firstCandidate['content'];
      if (content is! Map<String, dynamic>) return '';

      final parts = content['parts'];
      if (parts is! List || parts.isEmpty) return '';

      final textBuffer = StringBuffer();
      for (final part in parts) {
        if (part is! Map<String, dynamic>) continue;
        final text = part['text'];
        if (text is String && text.isNotEmpty) {
          textBuffer.write(text);
        }
      }
      return textBuffer.toString();
    } catch (_) {
      return '';
    }
  }

  String _stripDataPrefix(String line) {
    if (!line.startsWith(_dataPrefix)) return '';
    return line.substring(_dataPrefix.length).trim();
  }
}
