import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/app_navbar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(title: 'CareDrop'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Neighbor-to-neighbor giving.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Browse local requests, claim one, and drop it off. '
                  'CareDrop makes generosity simple, transparent, and local.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    CaredropButton(
                      label: 'Browse Requests',
                      onPressed: () => Navigator.pushNamed(context, '/browse'),
                    ),
                    CaredropButton(
                      label: 'Create Request',
                      onPressed: () => Navigator.pushNamed(context, '/create'),
                      filled: false,
                    ),
                    CaredropButton(
                      label: 'My Dashboard',
                      onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                      filled: false,
                    ),
                    CaredropButton(
                      label: 'Login / Register',
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      filled: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}