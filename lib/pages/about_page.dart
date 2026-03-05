import 'package:flutter/material.dart';
import '../widgets/footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero banner
          SizedBox(
            height: 380,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1619973226698-b77a5b5dd14b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjb25jZXJ0JTIwY3Jvd2QlMjBsaXZlJTIwbXVzaWN8ZW58MXx8fHwxNzcyNjQyMDUyfDA&ixlib=rb-4.1.0&q=80&w=1080',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1F2937)),
                ),
                Container(color: Colors.black.withOpacity(0.6)),
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('About Us',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              fontWeight: FontWeight.w400)),
                      SizedBox(height: 8),
                      Text('Creating music, sharing knowledge',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Our Story
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 768),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Our Story',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
                          SizedBox(height: 20),
                          Text(
                            "We're a band passionate about creating music and sharing our creative process with the world. Through our bandcam sessions on YouTube, we've built a community of music lovers, producers, and aspiring musicians who want to learn and create alongside us.",
                            style: TextStyle(color: Color(0xFF374151), fontSize: 15, height: 1.6),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "By offering our stem files, we're opening up our music for others to explore, remix, and learn from. Every track we release represents hours of collaboration, creativity, and dedication to our craft.",
                            style: TextStyle(color: Color(0xFF374151), fontSize: 15, height: 1.6),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Your support through purchasing our stems not only helps us continue making music but also contributes to the growth of a community that values transparency and collaboration in music production.",
                            style: TextStyle(color: Color(0xFF374151), fontSize: 15, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 64),

                    // Stats grid
                    _StatsGrid(isWide: isWide),
                    const SizedBox(height: 64),

                    // What you get
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text('What You Get',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 32),
                          Flex(
                            direction: isWide ? Axis.horizontal : Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: isWide ? 1 : 0,
                                child: _WhatYouGetColumn(
                                  title: 'High-Quality Files',
                                  items: [
                                    '24-bit/48kHz WAV format',
                                    'Individual instrument tracks',
                                    'Clean, professionally recorded audio',
                                    'Organized and labeled stems',
                                  ],
                                ),
                              ),
                              SizedBox(width: isWide ? 32 : 0, height: isWide ? 0 : 24),
                              Flexible(
                                flex: isWide ? 1 : 0,
                                child: _WhatYouGetColumn(
                                  title: 'License & Rights',
                                  items: [
                                    'Personal remix and derivative works',
                                    'Educational and learning purposes',
                                    'Portfolio and demonstration use',
                                    'Non-commercial creative projects',
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const AppFooter(),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final bool isWide;
  const _StatsGrid({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (Icons.music_video, '100+ Videos', 'Bandcam sessions and music content on YouTube'),
      (Icons.people, '50K+ Subscribers', 'Growing community of music enthusiasts'),
      (Icons.emoji_events, 'Professional Quality', 'Studio-grade recordings and production'),
      (Icons.favorite, 'Community First', 'Supporting musicians and creators worldwide'),
    ];

    if (isWide) {
      return Row(
        children: stats
            .map((s) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: _StatCard(icon: s.$1, title: s.$2, desc: s.$3))))
            .toList(),
      );
    }
    return Column(
      children: stats
          .map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _StatCard(icon: s.$1, title: s.$2, desc: s.$3),
              ))
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _StatCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 12),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 6),
        Text(desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
      ],
    );
  }
}

class _WhatYouGetColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  const _WhatYouGetColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('• $item',
                  style: const TextStyle(color: Color(0xFF374151), fontSize: 14)),
            )),
      ],
    );
  }
}
