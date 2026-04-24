import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/screens/info_screens.dart';
import 'package:indian_tex/widgets/category_circle.dart';
import 'package:indian_tex/widgets/festive_pattern_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(viewportFraction: 0.9);
  final _searchCtrl = TextEditingController();
  Timer? _timer;
  int _page = 0;

  static const _offerSlides = [
    (
      'assets/images/20 off.jpg',
      '20% OFF',
      'Festival Collection • Limited time',
      true,
    ),
    (
      'assets/images/plaza pant offer.png',
      'Viscose Plaza Pant Offer',
      'Premium comfort • Best seller',
      true,
    ),
    (
      'assets/images/chiffon shawl offer.png',
      'Chiffon Shawl Offer',
      'Elegant drape • Premium chiffon',
      true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) return;
      _page = (_page + 1) % _offerSlides.length;
      _pageController.animateToPage(
        _page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();

    return Scaffold(
      drawer: _HomeMenuDrawer(
        isLoggedIn: provider.isLoggedIn,
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            children: const [
              TextSpan(text: 'Indian '),
              TextSpan(
                text: 'Tex',
                style: TextStyle(
                  color: Color(0xFF8C1D40),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (!provider.isLoggedIn) {
                _showLoginRequiredSheet(context);
                return;
              }
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: FestivePatternBackground(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF3E0), Color(0xFFFFF8ED), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8C1D40), Color(0xFFD17B0F)],
                ),
              ),
              child: const Text(
                'Festive. Traditional. Premium Indian fashion for every celebration.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search sarees, shawls, kurti, accessories...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/listing',
                      arguments: _searchCtrl.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
              onSubmitted: (value) {
                Navigator.pushNamed(context, '/listing', arguments: value.trim());
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  return CategoryCircle(
                    category: category,
                    onTap: () {
                      Navigator.pushNamed(context, '/listing', arguments: category.name);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Offers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 190,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _offerSlides.length,
                onPageChanged: (value) => setState(() => _page = value),
                itemBuilder: (context, index) {
                  final offer = _offerSlides[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFFFFF1DF),
                      image: DecorationImage(
                        image: offer.$4 ? AssetImage(offer.$1) : NetworkImage(offer.$1) as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.65),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            offer.$2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            offer.$3,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _offerSlides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == index ? const Color(0xFF6C3BFF) : Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Fashion Accessories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _AccessoryTile(
                    imageUrl: 'assets/images/jwelery.jpeg',
                    title: 'Jewelry',
                  ),
                  _AccessoryTile(
                    imageUrl: 'assets/images/bags.jpg',
                    title: 'Bags',
                  ),
                  _AccessoryTile(
                    imageUrl: 'assets/images/dupatta.jpg',
                    title: 'Dupatta',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/listing'),
              child: const Text('View Products'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.12),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.diamond_outlined, color: Color(0xFF8C1D40)),
                      SizedBox(width: 6),
                      Text(
                        'Indian Tex',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Premium ethnic and festive wear crafted with Indian tradition and modern elegance.',
                  ),
                  SizedBox(height: 10),
                  Text('Instagram: @indiantexofficial'),
                  Text('WhatsApp:  0778894785'),
                  Text('Offline Store: 139/7, Muruthawala,Mawanella '),
                  Text('Telephone: 0777651323'),
                  Text('Open Hours: Mon-Sun, 10:00 AM - 9.00PM'),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoginRequiredSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Login Required',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Please login or create an account to open profile.'),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeMenuDrawer extends StatelessWidget {
  const _HomeMenuDrawer({required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFFFFF1DF),
                ),
                child: const Text(
                  'Quick Menu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),
              _MenuTile(
                title: 'About App',
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AboutAppScreen.routeName);
                },
              ),
              _MenuTile(
                title: 'Contact Us',
                icon: Icons.call_outlined,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ContactUsScreen.routeName);
                },
              ),
              const Divider(height: 24),
              _MenuTile(
                title: isLoggedIn ? 'Logged In' : 'Login',
                icon: Icons.login,
                onTap: () {
                  Navigator.pop(context);
                  if (!isLoggedIn) Navigator.pushNamed(context, '/login');
                },
              ),
              _MenuTile(
                title: 'Create Account',
                icon: Icons.person_add_alt_1_outlined,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8C1D40)),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

class _AccessoryTile extends StatelessWidget {
  const _AccessoryTile({
    required this.imageUrl,
    required this.title,
  });

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.65),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
