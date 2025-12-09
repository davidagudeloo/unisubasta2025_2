import 'package:flutter/material.dart';

class MessageFieldBox extends StatefulWidget {
  final Function(String) onSend;

  const MessageFieldBox({
    super.key,
    required this.onSend,
  });

  @override
  State<MessageFieldBox> createState() => _MessageFieldBoxState();
}

class _MessageFieldBoxState extends State<MessageFieldBox> {
  final TextEditingController controller = TextEditingController();

  void submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => submit(),
              decoration: const InputDecoration(
                hintText: "Escribe un mensaje...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: submit,
          )
        ],
      ),
    );
  }
}
