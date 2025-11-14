import 'package:flutter/material.dart';
import '../widgets/app_navbar.dart';
import '../services/supabase_service.dart';

class LoginPage extends StatefulWidget {
  final bool startInRegister;
  const LoginPage({super.key, this.startInRegister = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _displayName = TextEditingController();
  final _avatarUrl = TextEditingController();

  bool _isLogin = true;
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _isLogin = !widget.startInRegister;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(title: 'Login / Register'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    helperText: 'No email required. This becomes your handle.',
                  ),
                ),
                const SizedBox(height: 8),
                if (!_isLogin) ...[
                  TextField(
                    controller: _displayName,
                    decoration: const InputDecoration(
                      labelText: 'Display name',
                      helperText: 'Name we show on your profile / requests.',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _avatarUrl,
                    decoration: const InputDecoration(
                      labelText: 'Avatar URL (optional)',
                      helperText: 'Paste a link to a profile photo, or leave blank.',
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                if (_message != null)
                  Text(
                    _message!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _busy
                      ? null
                      : () async {
                          setState(() {
                            _busy = true;
                            _message = null;
                          });
                          try {
                            final supa = SupabaseService();
                            await supa.init();
                            if (_isLogin) {
                              await supa.signInWithUsername(
                                _username.text.trim(),
                                _password.text.trim(),
                              );
                            } else {
                              if (_displayName.text.trim().isEmpty) {
                                setState(() {
                                  _message =
                                      'Please enter a display name for your profile.';
                                });
                                _busy = false;
                                return;
                              }
                              await supa.signUpWithUsername(
                                username: _username.text.trim(),
                                password: _password.text.trim(),
                                displayName: _displayName.text.trim(),
                                avatarUrl: _avatarUrl.text.trim().isEmpty
                                    ? null
                                    : _avatarUrl.text.trim(),
                              );
                            }
                            if (mounted) {
                              Navigator.pushReplacementNamed(context, '/');
                            }
                          } catch (e) {
                            setState(() {
                              _message = e.toString();
                            });
                          } finally {
                            setState(() {
                              _busy = false;
                            });
                          }
                        },
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isLogin ? 'Login' : 'Create account'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? 'No account? Create one'
                        : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
