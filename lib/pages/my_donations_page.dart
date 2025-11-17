import 'package:flutter/material.dart';
import '../widgets/app_navbar.dart';
import '../models/request_model.dart';
import '../widgets/request_card.dart';
import '../services/supabase_service.dart';

class MyDonationsPage extends StatefulWidget {
  const MyDonationsPage({super.key});

  @override
  State<MyDonationsPage> createState() => _MyDonationsPageState();
}

class _MyDonationsPageState extends State<MyDonationsPage> {
  late Future<List<RequestModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<RequestModel>> _load() async {
    final supa = SupabaseService();
    await supa.init();
    return await supa.fetchMyRequests();
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
      //Todo: need two different dashboards for my requests and my donations to requests
      appBar: const AppNavBar(title: 'My Dashboard'),
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
                    child: Text('Error loading: ${snapshot.error}'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Center(child: Text('No requests yet.'));
                }
                return ListView(
                  children: items
                      .map(
                        (m) => RequestCard(
                          model: m,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/request',
                            arguments: m,
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

