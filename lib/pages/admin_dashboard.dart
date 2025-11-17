import 'package:flutter/material.dart';
import '../widgets/app_navbar.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Wire this to Supabase row-level security + filters later.
    return Scaffold(
      appBar: const AppNavBar(title: 'Admin Dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Moderation Queue (wire this to Supabase later)'),
                SizedBox(height: 8),
                Text('- Example: new requests needing review'),
                Text('- Example: flagged posts'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

