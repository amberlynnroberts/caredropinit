import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _loadingProfile = true;
  String? _displayName; // null = not logged in

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final supa = SupabaseService();
    await supa.init();

    if (supa.currentUser == null) {
      setState(() {
        _loadingProfile = false;
        _displayName = null;
      });
      return;
    }

    final profile = await supa.fetchMyProfile();
    setState(() {
      _loadingProfile = false;
      _displayName = profile?['display_name'] as String? ??
          profile?['username'] as String?;
    });
  }

  Future<void> _signOut() async {
    final supa = SupabaseService();
    await supa.signOut();
    setState(() {
      _displayName = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out')),
      );
    }
  }

  Widget _buildAuthAction() {
    if (_loadingProfile) {
      return const Padding(
        padding: EdgeInsets.only(right: 16),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    // Not logged in -> show Sign in / Register button
    if (_displayName == null) {
      return TextButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/login').then((_) => _loadProfile()),
        child: const Text('Sign in / Register'),
      );
    }

    // Logged in -> show "Hi, Name ▾" with Sign out menu
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'logout') {
          await _signOut();
        } else if (value == 'dashboard') {
          if (!mounted) return;
          Navigator.pushNamed(context, '/dashboard');
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'dashboard',
          child: Text('My dashboard'),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Text('Sign out'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text('Hi, ${_displayName!}'),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar so we can put the auth dropdown on the right
      appBar: AppBar(
        title: const Text('CareDrop'),
        actions: [
          _buildAuthAction(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero / overview
                Text(
                  'CareDrop makes local giving simple.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'CareDrop is a community-powered donation network that connects '
                  'people who want to give with neighbors who need support — quickly, '
                  'safely, and locally.',
                ),
                const SizedBox(height: 24),

                // What you can do
                Text(
                  'What you can do',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _FeatureCard(
                      icon: Icons.search,
                      title: 'Browse needs',
                      text:
                          'See real requests for essentials like food, clothing, and hygiene items in your area.',
                    ),
                    _FeatureCard(
                      icon: Icons.favorite_outline,
                      title: 'Fulfill a request',
                      text:
                          'Claim a request, purchase or gather the item, and drop it off at the agreed location.',
                    ),
                    _FeatureCard(
                      icon: Icons.add_box_outlined,
                      title: 'Ask for help',
                      text:
                          'Create a request for what you need and track when someone claims and fulfills it.',
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Call-to-actions
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => Navigator.pushNamed(context, '/browse'),
                      child: const Text('Browse requests'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/create'),
                      child: const Text('Create a request'),
                    ),
                    const SizedBox(width: 12),
                    if (_displayName == null)
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login')
                            .then((_) => _loadProfile()),
                        child: const Text('Sign in to track your impact'),
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

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
