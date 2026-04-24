import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/screens/cart_screen.dart';
import 'package:indian_tex/screens/checkout_screen.dart';
import 'package:indian_tex/screens/home_screen.dart';
import 'package:indian_tex/screens/info_screens.dart';
import 'package:indian_tex/screens/login_screen.dart';
import 'package:indian_tex/screens/order_tracking_screen.dart';
import 'package:indian_tex/screens/product_details_screen.dart';
import 'package:indian_tex/screens/product_listing_screen.dart';
import 'package:indian_tex/screens/profile_screen.dart';
import 'package:indian_tex/screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IndianTexApp());
}

class IndianTexApp extends StatelessWidget {
  const IndianTexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopProvider(),
      child: Consumer<ShopProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Indian Tex',
            debugShowCheckedModeBanner: false,
            themeMode: provider.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: _buildTheme(provider.accentColor, Brightness.light),
            darkTheme: _buildTheme(provider.accentColor, Brightness.dark),
            initialRoute: HomeScreen.routeName,
            routes: {
              LoginScreen.routeName: (_) => const LoginScreen(),
              RegisterScreen.routeName: (_) => const RegisterScreen(),
              HomeScreen.routeName: (_) => const HomeScreen(),
              ProductListingScreen.routeName: (_) => const ProductListingScreen(),
              ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
              CartScreen.routeName: (_) => const CartScreen(),
              CheckoutScreen.routeName: (_) => const CheckoutScreen(),
              ProfileScreen.routeName: (_) => const ProfileScreen(),
              OrderTrackingScreen.routeName: (_) => const OrderTrackingScreen(),
              AboutAppScreen.routeName: (_) => const AboutAppScreen(),
              ContactUsScreen.routeName: (_) => const ContactUsScreen(),
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(Color seed, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: seed,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      scaffoldBackgroundColor: isDark ? const Color(0xFF171220) : const Color(0xFFFFFBF4),
      cardColor: isDark ? const Color(0xFF231A32) : Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2B233B) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(46),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
