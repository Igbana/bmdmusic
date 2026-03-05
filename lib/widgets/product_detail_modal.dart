import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_state.dart';
import '../models/stem_file.dart';

class ProductDetailModal extends StatelessWidget {
  const ProductDetailModal({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.isDetailModalOpen || state.selectedProduct == null) {
      return const SizedBox.shrink();
    }
    return _ProductDetailDialog(product: state.selectedProduct!, state: state);
  }
}

class _ProductDetailDialog extends StatelessWidget {
  final StemFile product;
  final AppState state;

  const _ProductDetailDialog({required this.product, required this.state});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('en_US');
    return GestureDetector(
      onTap: state.closeDetailModal,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // prevent close when tapping dialog
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 720,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.title,
                                      style: const TextStyle(
                                          fontSize: 22, fontWeight: FontWeight.bold)),
                                  Text(product.artist,
                                      style: const TextStyle(
                                          fontSize: 14, color: Color(0xFF6B7280))),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: state.closeDetailModal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: double.infinity,
                            height: 280,
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFF374151),
                                child: const Icon(Icons.music_note, color: Colors.white54, size: 48),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Genre + price
                        Row(
                          children: [
                            _Badge(label: product.genre),
                            const SizedBox(width: 16),
                            Text('₦${formatter.format(product.price)}',
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(product.description,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF374151))),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Track info grid
                        const Text('Track Information',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        LayoutBuilder(builder: (context, constraints) {
                          final cols = constraints.maxWidth > 400 ? 4 : 2;
                          return _InfoGrid(product: product, cols: cols);
                        }),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Stem files
                        const Text('Included Stem Files',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.includeStems
                              .map((stem) => _StemChip(label: stem))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'All files delivered as high-quality WAV (24-bit/48kHz)',
                          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 16),

                        // YouTube button
                        if (product.videoUrl != null) ...[
                          const Divider(),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: const Text('Watch Original Video on YouTube'),
                              onPressed: () => launchUrl(Uri.parse(product.videoUrl!)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                                foregroundColor: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Add to cart button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              state.addToCart(product);
                              state.closeDetailModal();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text(
                              'Add to Cart - \$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final StemFile product;
  final int cols;

  const _InfoGrid({required this.product, required this.cols});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.speed, 'BPM', '${product.bpm}'),
      (Icons.music_note, 'Key', product.key),
      (Icons.access_time, 'Duration', product.duration),
      (Icons.queue_music, 'Stems', '${product.includeStems.length}'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: items.map((item) {
        return SizedBox(
          width: (cols == 4) ? 120 : 140,
          child: Row(
            children: [
              Icon(item.$1, size: 20, color: const Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.$2,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  Text(item.$3,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}

class _StemChip extends StatelessWidget {
  final String label;
  const _StemChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.music_note, size: 14, color: Color(0xFF6B7280)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}
