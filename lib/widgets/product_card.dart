import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/stem_file.dart';
import '../app_state.dart';

class ProductCard extends StatefulWidget {
  final StemFile product;
  final void Function(StemFile) onAddToCart;
  final void Function(StemFile) onViewDetails;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onViewDetails,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('en_US');
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: _hovered
              ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              GestureDetector(
                onTap: () => widget.onViewDetails(widget.product),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 256,
                      width: double.infinity,
                      child: Consumer<AppState>(
                        builder: (context, appState, _) {
                          return CachedNetworkImage(
                            imageUrl: widget.product.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFF374151),
                          child: const Icon(Icons.music_note, color: Colors.white54, size: 48),
                        ),
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x99000000)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Badge(label: widget.product.genre),
                          const SizedBox(height: 6),
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.music_note, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text('${widget.product.bpm} BPM',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(widget.product.duration,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                        const SizedBox(width: 16),
                        Text(widget.product.key,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        ...widget.product.includeStems.take(3).map(
                              (stem) => _OutlineBadge(label: stem),
                            ),
                        if (widget.product.includeStems.length > 3)
                          _OutlineBadge(label: '+${widget.product.includeStems.length - 3} more'),
                      ],
                    ),
                  ],
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₦${formatter.format(widget.product.price)}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => widget.onViewDetails(widget.product),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Details', style: TextStyle(fontSize: 13)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => widget.onAddToCart(widget.product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Add to Cart', style: TextStyle(fontSize: 13)),
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
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class _OutlineBadge extends StatelessWidget {
  final String label;
  const _OutlineBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87)),
    );
  }
}
