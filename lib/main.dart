import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'app_state.dart';
import 'pages/home_page.dart';
import 'pages/shop_page.dart';
import 'pages/about_page.dart';
import 'widgets/header.dart';
import 'widgets/cart_drawer.dart';
import 'widgets/product_detail_modal.dart';
import 'widgets/toast_overlay.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const BandStoreApp(),
    ),
  );
}

final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/shop', builder: (context, state) => const ShopPage()),
        GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
      ],
    ),
  ],
);

class BandStoreApp extends StatelessWidget {
  const BandStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Your Band Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      routerConfig: _router,
    );
  }
}

class _AppShell extends StatelessWidget {
  final Widget child;
  const _AppShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Stack(
        children: [
          child,
          // Cart drawer overlay
          const CartDrawer(),
          // Product detail modal overlay
          const ProductDetailModal(),
          // Toast
          const ToastOverlay(),
        ],
      ),
    );
  }
}
