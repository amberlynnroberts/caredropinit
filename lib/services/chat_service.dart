
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  ChatService._internal();

  static final ChatService _instance = ChatService._internal();

  factory ChatService() => _instance;

  final supabase = Supabase.instance.client;

  /// Create or fetch a conversation for this request.
  ///
  /// [requestId] - ID of the request (from your `requests` table)
  /// [requesterId] - auth user id of the requester
  /// [donorId] - auth user id of the donor (current user when claiming)
  Future<String> getOrCreateConversation(
    String requestId,
    String requesterId,
    String donorId,
  ) async {
    // Check if a conversation already exists for this request
    final existing = await supabase
        .from('conversations')
        .select()
        .eq('request_id', requestId)
        .maybeSingle();

    if (existing != null) {
      return existing['id'] as String;
    }

    // Create new conversation
    final data = await supabase.from('conversations').insert({
      'request_id': requestId,
      'requester_id': requesterId,
      'donor_id': donorId,
    }).select().single();

    return data['id'] as String;
  }

  /// Stream messages for realtime updates for a given conversation.
  Stream<List<Map<String, dynamic>>> subscribeMessages(String conversationId) {
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((rows) => rows.cast<Map<String, dynamic>>());
  }

  /// Send a message in the given conversation.
  Future<void> sendMessage(String conversationId, String text) async {
    final userId = supabase.auth.currentUser!.id;

    await supabase.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': userId,
      'body': text,
    });
  }

  /// Get unread message count for the current user in a conversation.
  Future<int> getUnreadCount(String conversationId) async {
    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('messages')
        .select('id')
        .eq('conversation_id', conversationId)
        .filter('read_at', 'is', 'null')
        .neq('sender_id', userId);

    return data.length;
  }
}
