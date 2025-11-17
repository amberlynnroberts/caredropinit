import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/request_model.dart';
import '../services/chat_service.dart';
import '../pages/chat_screen.dart';

class RequestCard extends StatelessWidget {
  final RequestModel model;
  final VoidCallback? onTap;
  final VoidCallback? onClaim;
  const RequestCard({super.key, required this.model, this.onTap, this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      model.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(model.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                model.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.place, size: 18),
                  const SizedBox(width: 6),
                  Text(model.location),
                  const Spacer(),
                  Text('Qty: ${model.quantity}'),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () async {
                      final chat = ChatService();
                      final donorId =
                          Supabase.instance.client.auth.currentUser?.id;
                      if (donorId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('You must be signed in to chat.')),
                        );
                        return;
                      }
                      // If the current user is the requester, they may not have a donor id
                      if (donorId == model.createdBy) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'You are the requester for this request.')),
                        );
                        return;
                      }
                      final conversationId = await chat.getOrCreateConversation(
                        model.id,
                        model.createdBy,
                        donorId,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            conversationId: conversationId,
                            otherUserName: model.createdBy,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (onClaim != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: onClaim,
                    child: const Text('Claim'),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
