import 'package:flutter/material.dart';
import '../widgets/app_navbar.dart';
import '../widgets/request_card.dart';
import '../models/request_model.dart';
import '../services/supabase_service.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  late Future<List<RequestModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<RequestModel>> _load() async {
    final supa = SupabaseService();
    await supa.init();
    return await supa.fetchRequests();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(title: 'Browse Requests'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<List<RequestModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading requests: ${snapshot.error}'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Center(child: Text('No requests yet.'));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return RequestCard(
                      model: item,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/request',
                        arguments: item,
                      ),
                      onClaim: item.status == 'pending'
                          ? () async {
                              final supa = SupabaseService();
                              await supa.updateRequestStatus(item.id, 'claimed');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Request claimed.'),
                                  ),
                                );
                                _refresh();
                              }
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

