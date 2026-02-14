import 'dart:typed_data';

import 'package:equatable/equatable.dart';

enum AttachmentType { image }

class MessageAttachment extends Equatable {
  const MessageAttachment({
    required this.type,
    required this.bytes,
    required this.mimeType,
    this.name,
  });

  final AttachmentType type;
  final Uint8List bytes;
  final String mimeType;
  final String? name;

  @override
  List<Object?> get props => [type, bytes, mimeType, name];
}
