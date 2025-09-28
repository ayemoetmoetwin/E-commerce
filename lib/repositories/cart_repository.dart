import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/local_storage_service.dart';

class CartRepository {
  final LocalStorageService _localStorageService;
  late Box<CartItem> _cartBox;

  CartRepository({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService {
    _cartBox = _localStorageService.cartBox;
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      return _cartBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  Future<void> addToCart(Product product, int quantity) async {
    try {
      final existingItem = _cartBox.get(product.id);

      if (existingItem != null) {
        // Update existing item
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
          updatedAt: DateTime.now(),
        );
        await _cartBox.put(product.id, updatedItem);
      } else {
        // Add new item
        final cartItem = CartItem(
          id: product.id,
          product: product,
          quantity: quantity,
          addedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _cartBox.put(product.id, cartItem);
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _cartBox.delete(productId);
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(productId);
        return;
      }

      final existingItem = _cartBox.get(productId);
      if (existingItem != null) {
        final updatedItem = existingItem.copyWith(
          quantity: quantity,
          updatedAt: DateTime.now(),
        );
        await _cartBox.put(productId, updatedItem);
      }
    } catch (e) {
      throw Exception('Failed to update cart item quantity: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartBox.clear();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<Map<String, dynamic>> calculateTotals(List<CartItem> items) async {
    try {
      double subtotal = 0.0;

      for (final item in items) {
        subtotal += item.totalPrice;
      }

      // Calculate tax (assuming 8.5% tax rate)
      const double taxRate = 0.085;
      double tax = subtotal * taxRate;

      // Calculate discount (this would come from applied coupons)
      double discount = 0.0;
      String? appliedCoupon;
      double couponDiscount = 0.0;

      // For demo purposes, let's add a simple discount logic
      if (subtotal > 100) {
        discount = subtotal * 0.1; // 10% discount for orders over $100
        appliedCoupon = 'SAVE10';
        couponDiscount = discount;
      }

      double total = subtotal + tax - discount;

      return {
        'subtotal': subtotal,
        'tax': tax,
        'discount': discount,
        'total': total,
        'appliedCoupon': appliedCoupon,
        'couponDiscount': couponDiscount,
      };
    } catch (e) {
      throw Exception('Failed to calculate totals: $e');
    }
  }

  Future<Map<String, dynamic>> applyCoupon(String couponCode) async {
    try {
      // Simple coupon validation logic
      final validCoupons = {
        'SAVE10': 0.1, // 10% discount
        'SAVE20': 0.2, // 20% discount
        'FREESHIP': 0.0, // Free shipping (would need different logic)
      };

      if (validCoupons.containsKey(couponCode.toUpperCase())) {
        return {
          'success': true,
          'message': 'Coupon applied successfully',
          'discount': validCoupons[couponCode.toUpperCase()],
        };
      } else {
        return {'success': false, 'message': 'Invalid coupon code'};
      }
    } catch (e) {
      throw Exception('Failed to apply coupon: $e');
    }
  }

  Future<void> removeCoupon() async {
    try {
      // Coupon removal functionality not implemented
    } catch (e) {
      throw Exception('Failed to remove coupon: $e');
    }
  }

  Future<int> getCartItemCount() async {
    try {
      final items = _cartBox.values.toList();
      return items.fold<int>(0, (sum, item) => sum + item.quantity);
    } catch (e) {
      return 0;
    }
  }

  Future<bool> isProductInCart(String productId) async {
    try {
      return _cartBox.containsKey(productId);
    } catch (e) {
      return false;
    }
  }
}
