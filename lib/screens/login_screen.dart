import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/providers/shop_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F1FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Indian Tex', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars' : null,
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            final success = context.read<ShopProvider>().login(
                                  email: emailCtrl.text.trim(),
                                  password: passCtrl.text.trim(),
                                );
                            if (!success) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Successfully logged in'),
                              ),
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text('Create account'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
