import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/entities/message_attachment.dart';
import '../../services/chat_image_picker.dart';
import 'chat_attachment_preview.dart';
import 'chat_input_row.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
  });

  final Future<void> Function(String text, MessageAttachment? attachment) onSend;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  final _imagePicker = ChatImagePicker();
  MessageAttachment? _attachment;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_attachment != null)
                  ChatAttachmentPreview(
                    attachment: _attachment!,
                    onRemove: _removeAttachment,
                  ),
                ChatInputRow(
                  controller: _controller,
                  onPickImage: _pickImage,
                  onSend: _send,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final attachment = await _imagePicker.pickFromGallery();
      if (attachment == null) return;

      if (!mounted) return;
      setState(() => _attachment = attachment);
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open gallery. Run flutter clean and restart the app.',
          ),
        ),
      );
    }
  }

  Future<void> _send() async {
    final text = _controller.text;
    final attachment = _attachment;
    _controller.clear();
    setState(() => _attachment = null);
    await widget.onSend(text, attachment);
  }

  void _removeAttachment() {
    setState(() => _attachment = null);
  }
}
