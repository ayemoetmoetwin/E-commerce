import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../services/local_storage_service.dart';

class FavoritesRepository {
  final LocalStorageService _localStorageService;
  late Box<String> _favoritesBox;
  late Box<Product> _productBox;

  FavoritesRepository({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService {
    _favoritesBox = _localStorageService.favoritesBox;
    _productBox = _localStorageService.productBox;
  }

  Future<List<Product>> getFavoriteProducts() async {
    try {
      final favoriteIds = _favoritesBox.values.toList();
      final favoriteProducts = <Product>[];

      for (final id in favoriteIds) {
        final product = _productBox.get(id);
        if (product != null) {
          favoriteProducts.add(product);
        }
      }

      return favoriteProducts;
    } catch (e) {
      throw Exception('Failed to get favorite products: $e');
    }
  }

  Future<void> addToFavorites(Product product) async {
    try {
      await _favoritesBox.put(product.id, product.id);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    try {
      await _favoritesBox.delete(productId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  Future<bool> isFavorite(String productId) async {
    try {
      return _favoritesBox.containsKey(productId);
    } catch (e) {
      return false;
    }
  }

  Future<void> clearFavorites() async {
    try {
      await _favoritesBox.clear();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }

  Future<int> getFavoritesCount() async {
    try {
      return _favoritesBox.length;
    } catch (e) {
      return 0;
    }
  }

  Future<List<String>> getFavoriteProductIds() async {
    try {
      return _favoritesBox.values.toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      final isCurrentlyFavorite = await isFavorite(product.id);

      if (isCurrentlyFavorite) {
        await removeFromFavorites(product.id);
      } else {
        await addToFavorites(product);
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
}
