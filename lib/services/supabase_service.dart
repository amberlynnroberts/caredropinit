import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';
import '../models/request_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  bool _initialized = false;
  SupabaseClient get client => Supabase.instance.client;

  Future<void> init() async {
    if (_initialized) return;
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    _initialized = true;
  }

  // ---------- AUTH (username-only) ----------

  Future<AuthResponse> signUpWithUsername({
    required String username,
    required String password,
    required String displayName,
    String? avatarUrl,
  }) async {
    final email = usernameToEmail(username);
    final res = await client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );

    final user = res.user;
    if (user != null) {
      await createProfile(
        userId: user.id,
        username: username,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
    }
    return res;
  }

  Future<AuthResponse> signInWithUsername(String username, String password) async {
    final email = usernameToEmail(username);
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  // ---------- PROFILE ----------

  Future<void> createProfile({
    required String userId,
    required String username,
    required String displayName,
    String? avatarUrl,
  }) async {
    await client.from('profiles').insert({
      'id': userId,
      'username': username,
      'display_name': displayName,
      'avatar_url': avatarUrl,
    });
  }

  Future<Map<String, dynamic>?> fetchMyProfile() async {
    final userId = currentUser?.id;
    if (userId == null) return null;
    final res = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (res == null) return null;
    return res as Map<String, dynamic>;
  }

  // ---------- REQUESTS CRUD ----------

  Future<List<RequestModel>> fetchRequests() async {
    final res = await client
        .from('requests')
        .select()
        .order('created_at', ascending: false);

    if (res == null) return [];

    final list = (res as List<dynamic>)
        .where((e) => e != null)
        .map((e) => RequestModel.fromMap(e as Map<String, dynamic>))
        .toList();

    // If you only want open requests:
    return list.where((r) => r.status == 'pending').toList();
  }



  Future<RequestModel> createRequest({
    required String title,
    required String description,
    required String category,
    required String location,
    required int quantity,
  }) async {
    final userId = currentUser?.id ?? 'anonymous';
    final payload = {
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'quantity': quantity,
      'status': 'pending',
      'created_by': userId,
    };
    final res = await client
        .from('requests')
        .insert(payload)
        .select()
        .single();
    return RequestModel.fromMap(res as Map<String, dynamic>);
  }

  Future<void> updateRequestStatus(String id, String status) async {
    await client.from('requests').update({'status': status}).eq('id', id);
  }

  Future<void> deleteRequest(String id) async {
    await client.from('requests').delete().eq('id', id);
  }

  Future<List<RequestModel>> fetchMyRequests() async {
    final userId = currentUser?.id;
    if (userId == null) return [];
    final res = await client
        .from('requests')
        .select()
        .eq('created_by', userId)
        .order('created_at', ascending: false);
    return (res as List<dynamic>)
        .map((e) => RequestModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> claimRequest(String id) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('Must be signed in to claim a request.');
    }

    await client.from('requests').update({
      'status': 'claimed',
      'claimed_by': user.id,
    }).eq('id', id);
  }
}