import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data/products.dart';
import '../models/stem_file.dart';
import '../widgets/product_card.dart';
import '../widgets/footer.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _searchQuery = '';
  String _sortBy = 'newest';

  List<StemFile> get _filteredProducts {
    final query = _searchQuery.toLowerCase();
    var filtered = stemProducts.where((p) =>
        p.title.toLowerCase().contains(query) ||
        p.genre.toLowerCase().contains(query)).toList();

    switch (_sortBy) {
      case 'price-low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price-high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final products = _filteredProducts;
    final isWide = MediaQuery.of(context).size.width >= 768;
    final width = MediaQuery.of(context).size.width;
    final cols = width >= 1024 ? 3 : (width >= 768 ? 2 : 1);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header banner
          Container(
            color: Colors.black,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Shop Stem Files',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w400)),
                    SizedBox(height: 8),
                    Text('Browse our complete collection of professional stem files',
                        style: TextStyle(color: Color(0xFFD1D5DB), fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    // Search + sort
                    Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: isWide ? 1 : 0,
                          child: SizedBox(
                            width: isWide ? double.infinity : MediaQuery.of(context).size.width - 48,
                            child: TextField(
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: 'Search stem files...',
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                        SizedBox(
                          width: isWide ? 200 : MediaQuery.of(context).size.width - 48,
                          child: DropdownButtonFormField<String>(
                            value: _sortBy,
                            onChanged: (v) => setState(() => _sortBy = v!),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: const [
                              DropdownMenuItem(value: 'newest', child: Text('Newest First')),
                              DropdownMenuItem(value: 'price-low', child: Text('Price: Low to High')),
                              DropdownMenuItem(value: 'price-high', child: Text('Price: High to Low')),
                              DropdownMenuItem(value: 'title', child: Text('Title: A to Z')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Products
                    if (products.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 64),
                        child: Center(
                          child: Text(
                            'No products found matching your search.',
                            style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                          ),
                        ),
                      )
                    else if (cols == 1)
                      Column(
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
                      )
                    else
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: cols,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 0.65,
                        children: products
                            .map((p) => ProductCard(
                                  product: p,
                                  onAddToCart: state.addToCart,
                                  onViewDetails: state.viewDetails,
                                ))
                            .toList(),
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
