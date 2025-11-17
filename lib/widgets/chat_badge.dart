
import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class UnreadBadge extends StatelessWidget {
  final String conversationId;
  final ChatService _chat = ChatService();

  UnreadBadge({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _chat.getUnreadCount(conversationId),
      builder: (context, snapshot) {
        final unread = snapshot.data ?? 0;
        if (unread <= 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Text(
            unread.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
