import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const routeName = '/about-app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Indian Tex')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            '''Welcome to Indian Tex – Since 2022

Your trusted destination for premium Indian imported fashion at affordable prices.

At Indian Tex, we are passionate about bringing you the latest fashion trends directly from India. Our collections are carefully selected to ensure high-quality fabrics, modern designs, and budget-friendly prices.

We provide Tops, Shalwars, Sarees, Gowns, Cord Sets, Leggings, Denims, and more festive collections.

Visit us at: 139/7, Muruthawala, Mawanella
Contact: indiantex@gmail.com | WhatsApp 0777651323''',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
        ),
      ),
    );
  }
}

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static const routeName = '/contact-us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Care: 0777651323'),
            SizedBox(height: 6),
            Text('WhatsApp: 0777651323'),
            SizedBox(height: 6),
            Text('Email: indiantex@gmail.com'),
            SizedBox(height: 6),
            Text('Store Address: 139/7, Muruthawala, Mawanella'),
            SizedBox(height: 6),
            Text('Open: Mon-Sun, 10:00 AM - 9:00 PM'),
          ],
        ),
      ),
    );
  }
}
