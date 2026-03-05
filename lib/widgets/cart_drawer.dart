import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/stem_file.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final formatter = NumberFormat.decimalPattern('en_US');

    if (!state.isCartOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        // Overlay
        GestureDetector(
          onTap: state.closeCart,
          child: Container(color: Colors.black54),
        ),
        // Drawer panel
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Material(
            elevation: 8,
            child: Container(
              width: MediaQuery.of(context).size.width < 600
                  ? MediaQuery.of(context).size.width
                  : 480,
              color: Colors.white,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: state.closeCart,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Shopping Cart',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          state.cartItems.isEmpty
                              ? 'Your cart is empty'
                              : '${state.cartItems.length} item${state.cartItems.length > 1 ? 's' : ''} in your cart',
                          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Items
                  if (state.cartItems.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add some stem files to get started!',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        itemCount: state.cartItems.length,
                        separatorBuilder: (_, __) => const Divider(height: 24),
                        itemBuilder: (context, index) {
                          final item = state.cartItems[index];
                          return _CartItemRow(item: item, state: state);
                        },
                      ),
                    ),

                  // Total & checkout
                  if (state.cartItems.isNotEmpty) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontSize: 18)),
                              Text(
                                '₦${formatter.format(state.cartTotal)}',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.checkout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                              child: const Text('Proceed to Checkout',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final AppState state;

  const _CartItemRow({required this.item, required this.state});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('en_US');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF374151),
                child: const Icon(Icons.music_note, color: Colors.white54),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(item.artist,
                  style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onPressed: () =>
                        state.updateQuantity(item.id, (item.quantity - 1).clamp(1, 99)),
                  ),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onPressed: () => state.updateQuantity(item.id, item.quantity + 1),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => state.removeItem(item.id),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '₦${formatter.format(item.price * item.quantity)}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(28, 28),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(icon, size: 14, color: Colors.black),
      ),
    );
  }
}
