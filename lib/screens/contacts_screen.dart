// lib/screens/contacts_screen.dart
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../models/contact.dart';
import '../models/message.dart';

class ContactsScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(
      id: '1',
      name: 'John Doe',
      lastMessage: 'Hello!',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
      unreadCount: 3,
      messageStatus: MessageStatus.read,
      profilePicUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    ),
    Contact(
      id: '2',
      name: 'Jane Smith',
      lastMessage: 'How are you?',
      lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
      messageStatus: MessageStatus.delivered,
      profilePicUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    ),
    Contact(
      id: '3',
      name: 'Alex Wilson',
      lastMessage: 'Meeting at 5?',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 30)),
      unreadCount: 1,
      messageStatus: MessageStatus.sent,
      profilePicUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
    ),
    Contact(
      id: '4',
      name: 'Sarah Johnson',
      lastMessage: 'See you tomorrow!',
      lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
      messageStatus: MessageStatus.read,
      profilePicUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
    ),
    Contact(
      id: '5',
      name: 'Mike Brown',
      lastMessage: 'Thanks for your help!',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 45)),
      unreadCount: 2,
      messageStatus: MessageStatus.delivered,
      profilePicUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Text(
            'WhatsApp',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Icon(Icons.camera_alt),
              Text('CHATS'),
              Text('STATUS'),
              Text('CALLS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Camera')),
            _buildChatsList(),
            Center(child: Text('Status')),
            Center(child: Text('Calls')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF25D366),
          child: Icon(Icons.message),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildChatsList() {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(0xFF128C7E),
            backgroundImage: contact.profilePicUrl != null
                ? NetworkImage(contact.profilePicUrl!)
                : null,
            child: contact.profilePicUrl == null
                ? Text(contact.name[0], style: TextStyle(color: Colors.white))
                : null,
          ),
          title: Text(
            contact.name,
            style: TextStyle(
              fontWeight:
                  contact.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Row(
            children: [
              if (contact.messageStatus != MessageStatus.pending)
                Icon(
                  contact.messageStatus == MessageStatus.read
                      ? Icons.done_all
                      : Icons.done,
                  size: 16,
                  color: contact.messageStatus == MessageStatus.read
                      ? Colors.blue
                      : Colors.grey,
                ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  contact.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _getFormattedTime(contact.lastMessageTime),
                style: TextStyle(
                  fontSize: 12,
                  color:
                      contact.unreadCount > 0 ? Color(0xFF25D366) : Colors.grey,
                ),
              ),
              if (contact.unreadCount > 0)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contact.unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(contact: contact)),
          ),
        );
      },
    );
  }

  String _getFormattedTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      return '${diff.inDays ~/ 7} weeks ago';
    } else if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30} months ago';
    } else {
      return '${diff.inDays ~/ 365} years ago';
    }
  }
}
