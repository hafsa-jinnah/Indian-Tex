import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/providers/shop_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telephone Number'),
                validator: (v) => (v == null || v.trim().length < 8) ? 'Enter valid telephone' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressCtrl,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Home Address'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter home address' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Create Password'),
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (v) => v != passCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final success = context.read<ShopProvider>().register(
                          name: nameCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          homeAddress: addressCtrl.text.trim(),
                          telephone: phoneCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                          confirmPassword: confirmCtrl.text.trim(),
                        );
                    if (!success) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully logged in')),
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  }
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
