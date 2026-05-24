// ignore_for_file: use_build_context_synchronousl
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter name'
                    : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter valid email'
                    : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Telephone Number'),
                validator: (v) => (v == null || v.trim().length < 8)
                    ? 'Enter valid telephone'
                    : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: addressCtrl,
                minLines: 2,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: 'Home Address'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter home address'
                    : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Create Password'),
                validator: (v) => (v == null || v.length < 6)
                    ? 'Min 6 chars'
                    : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: confirmCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: (v) => v != passCtrl.text
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 14),

              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailCtrl.text.trim(),
                        password: passCtrl.text.trim(),
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account Created Successfully'),
                        ),
                      );

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(e.message ?? 'Registration Failed'),
                        ),
                      );
                    }
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