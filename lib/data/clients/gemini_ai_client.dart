import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../domain/entities/message.dart';
import 'ai_client.dart';
import 'ai_client_exception.dart';
import 'gemini/gemini_request_builder.dart';
import 'gemini/gemini_stream_parser.dart';

class GeminiAiClient implements AiClient {
  GeminiAiClient({
    Dio? dio,
    String? apiKey,
    String? model,
    GeminiRequestBuilder? requestBuilder,
    GeminiStreamParser? streamParser,
  })
      : _dio = dio ?? Dio(),
        _apiKey = apiKey ?? AppConfig.geminiApiKey,
        _model = model ?? AppConfig.geminiModel,
        _requestBuilder = requestBuilder ?? const GeminiRequestBuilder(),
        _streamParser = streamParser ?? const GeminiStreamParser();

  final Dio _dio;
  final String _apiKey;
  final String _model;
  final GeminiRequestBuilder _requestBuilder;
  final GeminiStreamParser _streamParser;

  @override
  Stream<Message> streamChatCompletion({
    required List<Message> history,
    required Message userMessage,
    Map<String, String>? extraHeaders,
  }) async* {
    if (_apiKey.isEmpty) {
      throw const AiClientException(
        'Missing GEMINI_API_KEY. Run with --dart-define=GEMINI_API_KEY=YOUR_KEY.',
      );
    }

    final url = _requestBuilder.buildUrl(_model);
    final payload = _requestBuilder.buildPayload(
      history: history,
      userMessage: userMessage,
    );

    try {
      final response = await _dio.post<ResponseBody>(
        url,
        data: payload,
        options: Options(
          responseType: ResponseType.stream,
          headers: _requestBuilder.buildHeaders(
            apiKey: _apiKey,
            extraHeaders: extraHeaders,
          ),
        ),
      );

      final stream = _streamParser.decodeSseLines(response.data!.stream);

      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final buffer = StringBuffer();

      await for (final line in stream) {
        if (_streamParser.isDoneLine(line)) break;

        final text = _streamParser.extractTextFromLine(line);
        if (text.isEmpty) continue;

        buffer.write(text);
        yield Message(
          id: id,
          role: MessageRole.assistant,
          content: buffer.toString(),
          createdAt: DateTime.now(),
          status: MessageStatus.delivered,
        );
      }
    } on DioException catch (error) {
      throw AiClientException(await _buildDioErrorMessage(error));
    } catch (error) {
      throw AiClientException('Unexpected Gemini error: $error');
    }
  }

  Future<String> _buildDioErrorMessage(DioException error) async {
    final statusCode = error.response?.statusCode;
    final details = await _extractServerError(error.response?.data);
    if (statusCode != null) {
      final hint = _statusHint(statusCode);
      if (hint.isEmpty) {
        return 'Gemini request failed ($statusCode): $details';
      }
      return 'Gemini request failed ($statusCode): $details. $hint';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Network timeout. Check internet connection.';
      case DioExceptionType.connectionError:
        return 'Connection error. Ensure emulator/device has internet.';
      default:
        return 'Request failed: ${error.message ?? 'Unknown error'}';
    }
  }

  Future<String> _extractServerError(dynamic data) async {
    if (data == null) return 'No server details.';
    if (data is String) return _extractMessageFromJsonText(data);
    if (data is ResponseBody) {
      return _extractServerErrorFromResponseBody(data);
    }
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String && message.isNotEmpty) {
          return _truncate(message);
        }
      }
      return _truncate(jsonEncode(data));
    }
    return _truncate(data.toString());
  }

  Future<String> _extractServerErrorFromResponseBody(ResponseBody body) async {
    try {
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in body.stream) {
        bytes.add(chunk);
      }
      final text = utf8.decode(
        bytes.toBytes(),
        allowMalformed: true,
      );
      if (text.trim().isEmpty) return 'No server details.';
      return _extractMessageFromJsonText(text);
    } catch (_) {
      return 'No server details.';
    }
  }

  String _extractMessageFromJsonText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 'No server details.';
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final error = decoded['error'];
        if (error is Map<String, dynamic>) {
          final message = error['message'];
          if (message is String && message.trim().isNotEmpty) {
            return _truncate(message);
          }
        }
      }
    } catch (_) {
      // Not JSON; fall back to raw text.
    }
    return _truncate(trimmed);
  }

  String _statusHint(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Check model name and request payload.';
      case 401:
        return 'API key is missing or invalid.';
      case 403:
        return 'Key permissions/restrictions are blocking this app.';
      case 404:
        return 'Model endpoint not found for this account.';
      case 429:
        return 'Quota/rate limit reached. Wait or upgrade plan.';
      default:
        if (statusCode >= 500) return 'Gemini service is temporarily unavailable.';
        return '';
    }
  }

  String _truncate(String input, {int max = 220}) {
    if (input.length <= max) return input;
    return '${input.substring(0, max)}...';
  }
}
