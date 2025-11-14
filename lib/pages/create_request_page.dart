import 'package:flutter/material.dart';
import '../widgets/app_navbar.dart';
import '../services/supabase_service.dart';

class CreateRequestPage extends StatefulWidget {
  const CreateRequestPage({super.key});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _location = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  String _category = 'food';
  bool _saving = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(title: 'Create Request'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _desc,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  DropdownButtonFormField(
                    value: _category,
                    items: const [
                      DropdownMenuItem(value: 'food', child: Text('Food')),
                      DropdownMenuItem(value: 'hygiene', child: Text('Hygiene')),
                      DropdownMenuItem(
                          value: 'clothing', child: Text('Clothing')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (v) {
                      setState(() => _category = v as String);
                    },
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  TextFormField(
                    controller: _location,
                    decoration: const InputDecoration(
                        labelText: 'Pickup/Drop-off Area'),
                  ),
                  TextFormField(
                    controller: _quantity,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: _saving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() {
                                _saving = true;
                                _error = null;
                              });
                              try {
                                final supa = SupabaseService();
                                await supa.init();
                                final qty = int.tryParse(_quantity.text) ?? 1;
                                await supa.createRequest(
                                  title: _title.text.trim(),
                                  description: _desc.text.trim(),
                                  category: _category,
                                  location: _location.text.trim(),
                                  quantity: qty,
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Request created.'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                setState(() {
                                  _error = e.toString();
                                });
                              } finally {
                                setState(() {
                                  _saving = false;
                                });
                              }
                            },
                      child: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

