import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data/products.dart';
import '../widgets/hero_section.dart';
import '../widgets/product_card.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final featured = stemProducts.take(3).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          const HeroSection(),

          // Featured section
          Container(
            color: const Color(0xFFF9FAFB),
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  children: [
                    const Text(
                      'Featured Stem Files',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'High-quality multitrack stems from our most popular bandcam sessions and live performances',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    _ResponsiveGrid(products: featured, state: state),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/shop'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text('View All Stem Files',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Why buy section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: _WhyBuySection(),
              ),
            ),
          ),

          const AppFooter(),
        ],
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final List products;
  final AppState state;
  const _ResponsiveGrid({required this.products, required this.state});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width >= 1024 ? 3 : (width >= 768 ? 2 : 1);

    return LayoutBuilder(builder: (context, constraints) {
      if (cols == 1) {
        return Column(
          children: products
              .map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: ProductCard(
                      product: p,
                      onAddToCart: state.addToCart,
                      onViewDetails: state.viewDetails,
                    ),
                  ))
              .toList(),
        );
      }
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: cols,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 1,
        children: products
            .map((p) => ProductCard(
                  product: p,
                  onAddToCart: state.addToCart,
                  onViewDetails: state.viewDetails,
                ))
            .toList(),
      );
    });
  }
}

class _WhyBuySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;

    final benefits = [
      ('Professional Quality', '24-bit/48kHz WAV files recorded with professional studio equipment'),
      ('Remix Rights', 'License included for personal remixes and educational use'),
      ('Instant Download', 'Get immediate access to all stem files after purchase'),
      ('Support Independent Music', 'Your purchase directly supports our band and future content'),
    ];

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Why Buy Our Stems?',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 24),
        ...benefits.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('✓', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.$1,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(b.$2,
                            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );

    final rightImage = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 380,
        width: double.infinity,
        // child: Image.network(
        //   // 'https://images.unsplash.com/photo-1708058913688-bcdf212f24ab?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtdXNpY2lhbiUyMGhlYWRwaG9uZXMlMjBwcm9kdWNpbmd8ZW58MXx8fHwxNzcyNjg5ODg0fDA&ixlib=rb-4.1.0&q=80&w=1080',
        //   'https://yt3.googleusercontent.com/br09wRVO9x09HVJuV7K4PEPg-n7Kix5TGTmKKwy42lHEToGSD74euz8ybJydm3weo7oUXkRQ8w=s160-c-k-c0x00ffffff-no-rj',
        //   fit: BoxFit.cover,
        //   errorBuilder: (_, __, ___) => Container(color: const Color(0xFF374151)),
        // ),
        child: Image.asset(
          'dp.jpeg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: const Color(0xFF374151)),
        ),
      ),
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: leftColumn),
          const SizedBox(width: 48),
          Expanded(child: rightImage),
        ],
      );
    }
    return Column(
      children: [leftColumn, const SizedBox(height: 32), rightImage],
    );
  }
}
