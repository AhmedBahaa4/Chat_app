import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.systemPrompt,
  });

  final String id;
  final String title;
  final DateTime updatedAt;
  final String? systemPrompt;

  Conversation copyWith({
    String? id,
    String? title,
    DateTime? updatedAt,
    String? systemPrompt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      systemPrompt: systemPrompt ?? this.systemPrompt,
    );
  }

  @override
  List<Object?> get props => [id, title, updatedAt, systemPrompt];
}
