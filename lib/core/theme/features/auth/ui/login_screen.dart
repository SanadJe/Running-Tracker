import 'package:flutter/material.dart';
import 'package:gano/core/theme/widgets/app_button.dart';
import 'package:gano/core/theme/widgets/app_text_field.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().signIn(
            email: _email.text,
            password: _password.text,
          );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().signUp(
            email: _email.text,
            password: _password.text,
          );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(
              controller: _email,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                return null;
              },
              maxLines: 1,
              isPassword: false,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _password,
              label: 'Password',
              isPassword: true,
              validator: (value) {
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            if (_loading)
              const CircularProgressIndicator()
            else ...[
              AppButton(text: 'Sign In', onPressed: _signIn),
              const SizedBox(height: 12),
              AppButton(text: 'Create Account', onPressed: _signUp),
            ],
          ],
        ),
      ),
    );
  }
}
