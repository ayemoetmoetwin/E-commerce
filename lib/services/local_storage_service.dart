import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _productBoxName = 'products';
  static const String _cartBoxName = 'cart';
  static const String _favoritesBoxName = 'favorites';
  static const String _userBoxName = 'user';

  late Box<Product> _productBox;
  late Box<CartItem> _cartBox;
  late Box<String> _favoritesBox;
  late Box<User> _userBox;

  Box<Product> get productBox => _productBox;
  Box<CartItem> get cartBox => _cartBox;
  Box<String> get favoritesBox => _favoritesBox;
  Box<User> get userBox => _userBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(CartItemAdapter());
    Hive.registerAdapter(UserAdapter());

    // Open boxes
    _productBox = await Hive.openBox<Product>(_productBoxName);
    _cartBox = await Hive.openBox<CartItem>(_cartBoxName);
    _favoritesBox = await Hive.openBox<String>(_favoritesBoxName);
    _userBox = await Hive.openBox<User>(_userBoxName);
  }

  Future<void> close() async {
    await _productBox.close();
    await _cartBox.close();
    await _favoritesBox.close();
    await _userBox.close();
  }

  Future<void> clearAll() async {
    await _productBox.clear();
    await _cartBox.clear();
    await _favoritesBox.clear();
    await _userBox.clear();
  }

  // Product methods
  Future<void> saveProduct(Product product) async {
    await _productBox.put(product.id, product);
  }

  Future<Product?> getProduct(String id) async {
    return _productBox.get(id);
  }

  Future<List<Product>> getAllProducts() async {
    return _productBox.values.toList();
  }

  Future<void> deleteProduct(String id) async {
    await _productBox.delete(id);
  }

  // Cart methods
  Future<void> saveCartItem(CartItem cartItem) async {
    await _cartBox.put(cartItem.id, cartItem);
  }

  Future<CartItem?> getCartItem(String id) async {
    return _cartBox.get(id);
  }

  Future<List<CartItem>> getAllCartItems() async {
    return _cartBox.values.toList();
  }

  Future<void> deleteCartItem(String id) async {
    await _cartBox.delete(id);
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
  }

  // Favorites methods
  Future<void> addToFavorites(String productId) async {
    await _favoritesBox.put(productId, productId);
  }

  Future<void> removeFromFavorites(String productId) async {
    await _favoritesBox.delete(productId);
  }

  Future<bool> isFavorite(String productId) async {
    return _favoritesBox.containsKey(productId);
  }

  Future<List<String>> getFavoriteIds() async {
    return _favoritesBox.values.toList();
  }

  Future<void> clearFavorites() async {
    await _favoritesBox.clear();
  }

  // User methods
  Future<void> saveUser(User user) async {
    await _userBox.put('current_user', user);
  }

  Future<User?> getCurrentUser() async {
    return _userBox.get('current_user');
  }

  Future<void> deleteUser() async {
    await _userBox.delete('current_user');
  }

  Future<bool> isUserLoggedIn() async {
    return _userBox.containsKey('current_user');
  }
}
