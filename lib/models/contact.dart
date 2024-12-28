import 'message.dart';

class Contact {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final MessageStatus messageStatus;
  final String? profilePicUrl;

  Contact({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.messageStatus = MessageStatus.sent,
    this.profilePicUrl,
  });
}