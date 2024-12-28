class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.pending,
  });
}

enum MessageStatus {
  pending,   // Clock icon
  sent,      // Single tick
  delivered, // Double tick
  read       // Blue double tick
}