import 'package:flutter/material.dart';
import '../widgets/app_navbar.dart';
import '../models/request_model.dart';
import '../services/supabase_service.dart';

class RequestDetailsPage extends StatelessWidget {
  const RequestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestModel model =
        ModalRoute.of(context)!.settings.arguments as RequestModel;
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
              FilledButton(
                onPressed: () async {
                  final supa = SupabaseService();
                  await supa.updateRequestStatus(model.id, 'claimed');
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
            ],
          ),
        ),
      ),
    );
  }
}

