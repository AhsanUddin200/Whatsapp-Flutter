// lib/widgets/chat_input_field.dart
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatInputField({required this.onSendMessage});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.emoji_emotions_outlined),
          onPressed: () {},
          color: Color(0xFF075E54),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Type a message',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.attach_file),
          onPressed: () {},
          color: Color(0xFF075E54),
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {},
          color: Color(0xFF075E54),
        ),
        Container(
          margin: EdgeInsets.only(right: 4),
          child: CircleAvatar(
            backgroundColor: Color(0xFF075E54),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onSendMessage(_controller.text);
                  _controller.clear();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
