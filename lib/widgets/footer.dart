import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: isWide ? _WideFooterContent() : _NarrowFooterContent(),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 32),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF1F2937))),
            ),
            child: const Text(
              '© 2026 BMD Music Home. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _WideFooterContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _BrandColumn()),
        const SizedBox(width: 32),
        Expanded(child: _ShopColumn()),
        const SizedBox(width: 32),
        Expanded(child: _SupportColumn()),
        const SizedBox(width: 32),
        Expanded(child: _SocialColumn()),
      ],
    );
  }
}

class _NarrowFooterContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BrandColumn(),
        const SizedBox(height: 32),
        _ShopColumn(),
        const SizedBox(height: 32),
        _SupportColumn(),
        const SizedBox(height: 32),
        _SocialColumn(),
      ],
    );
  }
}

class _BrandColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.music_note, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text('BMD Music Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Official stem files from our bandcam sessions and music videos.',
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _hovered ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ShopColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shop', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        _FooterLink(label: 'All Stem Files', onTap: () => context.go('/shop')),
        const SizedBox(height: 8),
        _FooterLink(label: 'Latest Releases', onTap: () => context.go('/shop')),
        const SizedBox(height: 8),
        _FooterLink(label: 'Popular Tracks', onTap: () => context.go('/shop')),
      ],
    );
  }
}

class _SupportColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        _FooterLink(label: 'FAQ', onTap: () {}),
        const SizedBox(height: 8),
        _FooterLink(label: 'Licensing', onTap: () {}),
        const SizedBox(height: 8),
        _FooterLink(label: 'Contact', onTap: () {}),
      ],
    );
  }
}

class _SocialColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Follow Us', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        SizedBox(height: 16),
        Row(
          children: [
            _SocialIcon(icon: Icons.play_arrow, url: 'https://youtube.com/@bmdmusichome?si=dITQix3db2sKd9EP'),
            SizedBox(width: 16),
            _SocialIcon(icon: Icons.camera_alt_outlined, url: 'https://www.instagram.com/bishopmarcusdaniel?igsh=MWRsNmFkcXd0Ym5ubA%3D%3D&utm_source=qr'),
            SizedBox(width: 16),
            _SocialIcon(icon: Icons.tiktok, url: 'https://www.tiktok.com/@_bishopmarcusdaniel?_r=1&_t=ZS-94QZXr6UjaO'),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: Icon(
          widget.icon,
          color: _hovered ? const Color(0xFF9CA3AF) : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
