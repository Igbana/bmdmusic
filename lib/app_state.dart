import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/stem_file.dart';

class AppState extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  bool _isCartOpen = false;
  StemFile? _selectedProduct;
  bool _isDetailModalOpen = false;
  String? _toastMessage;

  List<CartItem> get cartItems => _cartItems;
  bool get isCartOpen => _isCartOpen;
  StemFile? get selectedProduct => _selectedProduct;
  bool get isDetailModalOpen => _isDetailModalOpen;
  String? get toastMessage => _toastMessage;

  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addToCart(StemFile product) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == product.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
      _showToast('Updated quantity in cart');
    } else {
      _cartItems = [..._cartItems, CartItem.fromStemFile(product)];
      _showToast('Added to cart');
    }
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    _cartItems = _cartItems.map((item) {
      if (item.id == id) return item.copyWith(quantity: quantity);
      return item;
    }).toList();
    notifyListeners();
  }

  void removeItem(String id) {
    _cartItems = _cartItems.where((item) => item.id != id).toList();
    _showToast('Removed from cart');
    notifyListeners();
  }

  void openCart() {
    _isCartOpen = true;
    notifyListeners();
  }

  void closeCart() {
    _isCartOpen = false;
    notifyListeners();
  }

  void viewDetails(StemFile product) {
    _selectedProduct = product;
    _isDetailModalOpen = true;
    notifyListeners();
  }

  void closeDetailModal() {
    _isDetailModalOpen = false;
    notifyListeners();
  }

  void checkout() {
    _showToast('Checkout functionality coming soon! This would integrate with a payment processor.');
    _isCartOpen = false;
    notifyListeners();
  }

  void _showToast(String message) {
    _toastMessage = message;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      _toastMessage = null;
      notifyListeners();
    });
  }

  void clearToast() {
    _toastMessage = null;
    notifyListeners();
  }
}
