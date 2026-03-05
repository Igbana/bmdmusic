import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cartCount = state.cartItemCount;
    final isWide = MediaQuery.of(context).size.width >= 768;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      // shadowColor: Colors.black12,
      // surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Logo
            InkWell(
              onTap: () => context.go('/'),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    // const Icon(Icons.music_note, size: 24, color: Colors.black),
                    Image.asset('black_logo.png', width: 64, height: 64,),
                    const SizedBox(width: 8),
                    Text(
                      'BMD Music Home',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Nav links (desktop only)
            if (isWide) ...[
              const _NavLink(label: 'Home', path: '/'),
              const SizedBox(width: 24),
              const _NavLink(label: 'Shop', path: '/shop'),
              const SizedBox(width: 24),
              const _NavLink(label: 'About', path: '/about'),
              const SizedBox(width: 24),
              const Spacer(),
            ],

            // Cart button
            Stack(
              clipBehavior: Clip.none,
              children: [
                OutlinedButton(
                  onPressed: state.openCart,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(40, 40),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.black),
                ),
                if (cartCount > 0)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String path;
  const _NavLink({required this.label, required this.path});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.path),
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
              fontSize: _hovered ? 18 : 16,
              color: _hovered ? Colors.black : Colors.black87,
              decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
            ), duration: Durations.short1,
          child: Text(
            widget.label,
          ),
        ),
      ),
    );
  }
}
