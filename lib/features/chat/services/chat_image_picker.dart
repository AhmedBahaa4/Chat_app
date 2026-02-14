import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../../domain/entities/message_attachment.dart';

class ChatImagePicker {
  ChatImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<MessageAttachment?> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    final mime = lookupMimeType(file.path, headerBytes: bytes) ??
        'image/${file.path.split('.').last}';

    return MessageAttachment(
      type: AttachmentType.image,
      bytes: Uint8List.fromList(bytes),
      mimeType: mime,
      name: file.name,
    );
  }
}
