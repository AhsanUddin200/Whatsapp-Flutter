// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/message.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input_field.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final Contact contact;

  ChatScreen({required this.contact});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  List<Message> messages = [];
  Timer? _statusTimer;

  // Add this map for predefined replies
  final Map<String, String> autoReplies = {
    'hello': 'Hi! How are you?',
    'how are you': 'I\'m good, thanks! Where are you?',
    'where are you':
        'On my way! Will reach home in 50 minutes, then we can talk properly.',
    'ok': 'Great! See you soon.',
    'bye': 'Goodbye! Take care.',
    'good morning': 'Good morning! Have a great day!',
    'good night': 'Good night! Sleep well.',
  };

  @override
  void initState() {
    super.initState();
    // Simulate receiving messages
    _simulateReceivedMessage();
    // Start status update timer
    _startStatusTimer();
  }

  void _simulateReceivedMessage() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        messages.add(
          Message(
            id: DateTime.now().toString(),
            text: "Hi! How are you?",
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  void _startStatusTimer() {
    _statusTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        for (var i = 0; i < messages.length; i++) {
          if (messages[i].isMe) {
            var message = messages[i];
            var newStatus = _getNextStatus(message.status);
            messages[i] = Message(
              id: message.id,
              text: message.text,
              isMe: message.isMe,
              timestamp: message.timestamp,
              status: newStatus,
            );
          }
        }
      });
    });
  }

  MessageStatus _getNextStatus(MessageStatus current) {
    switch (current) {
      case MessageStatus.pending:
        return MessageStatus.sent;
      case MessageStatus.sent:
        return MessageStatus.delivered;
      case MessageStatus.delivered:
        return MessageStatus.read;
      default:
        return current;
    }
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        Message(
          id: DateTime.now().toString(),
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
          status: MessageStatus.pending,
        ),
      );
    });

    // Add auto-reply logic
    _handleAutoReply(text.toLowerCase());
  }

  void _handleAutoReply(String userMessage) {
    String? reply = autoReplies[userMessage];
    if (reply != null) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          messages.add(
            Message(
              id: DateTime.now().toString(),
              text: reply,
              isMe: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      });
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back, color: Colors.white),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contact.profilePicUrl != null
                    ? NetworkImage(widget.contact.profilePicUrl!)
                    : null,
                child: widget.contact.profilePicUrl == null
                    ? Text(
                        widget.contact.name[0],
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contact.name,
              style: const TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'online',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/originals/97/c0/07/97c00759d90d786d9b6096d274ad3e07.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatMessageBubble(
                    message: messages[index],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.white,
              child: ChatInputField(onSendMessage: _sendMessage),
            ),
          ],
        ),
      ),
    );
  }
}
