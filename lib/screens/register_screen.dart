// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  bool isLoading = false;

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

  Future<void> registerUser() async {

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      // =========================
      // CREATE AUTH ACCOUNT
      // =========================

      final credential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(

        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      // =========================
      // SAVE USER DATA
      // =========================

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({

        'name': nameCtrl.text.trim(),

        'email': emailCtrl.text.trim(),

        'address': addressCtrl.text.trim(),

        'telephone': phoneCtrl.text.trim(),

        'createdAt': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account Created Successfully',
          ),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Registration Failed',
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Register'),
      ),

      body: Padding(

        padding: const EdgeInsets.all(18),

        child: Form(

          key: formKey,

          child: ListView(

            children: [

              TextFormField(
                controller: nameCtrl,

                decoration: const InputDecoration(
                  labelText: 'Name',
                ),

                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Enter name'
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: emailCtrl,

                decoration: const InputDecoration(
                  labelText: 'Email',
                ),

                validator: (v) =>
                    (v == null || !v.contains('@'))
                        ? 'Enter valid email'
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: phoneCtrl,

                keyboardType: TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: 'Telephone Number',
                ),

                validator: (v) =>
                    (v == null || v.trim().length < 8)
                        ? 'Enter valid telephone'
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: addressCtrl,

                minLines: 2,
                maxLines: 3,

                decoration: const InputDecoration(
                  labelText: 'Home Address',
                ),

                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Enter home address'
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: passCtrl,

                obscureText: true,

                decoration: const InputDecoration(
                  labelText: 'Create Password',
                ),

                validator: (v) =>
                    (v == null || v.length < 6)
                        ? 'Min 6 chars'
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: confirmCtrl,

                obscureText: true,

                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),

                validator: (v) =>
                    v != passCtrl.text
                        ? 'Passwords do not match'
                        : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(

                onPressed:
                    isLoading
                        ? null
                        : registerUser,

                child:
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Create Account',
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}