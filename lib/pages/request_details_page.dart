import 'package:flutter/material.dart';
import '../widgets/app_navbar.dart';
import '../models/request_model.dart';
import '../services/supabase_service.dart';

class RequestDetailsPage extends StatelessWidget {
  const RequestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! RequestModel) {
      return const Scaffold(
        body: Center(
          child: Text('No request data was provided.'),
        ),
      );
    }

    final RequestModel model = args;
    final supa = SupabaseService();
    final currentUserId = supa.currentUser?.id;
    final isMine = currentUserId != null && currentUserId == model.createdBy;

    return Scaffold(
      appBar: AppNavBar(title: model.title),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.place, size: 18),
                  const SizedBox(width: 6),
                  Text(model.location),
                  const SizedBox(width: 16),
                  Text('Qty: ${model.quantity}'),
                ],
              ),
              const SizedBox(height: 24),

              // Claim button (same rules as browse, if you want)
              FilledButton(
                onPressed: () async {
                  await supa.claimRequest(model.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You claimed this request.'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Claim'),
              ),

              const SizedBox(height: 16),

              if (isMine)
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  label: const Text('Delete this request'),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete request?'),
                        content: const Text(
                          'This will permanently remove this request. '
                          'This cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed != true) return;

                    await supa.deleteRequest(model.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request deleted.'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
