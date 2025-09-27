import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../services/local_storage_service.dart';
import '../services/api_service.dart';
import '../bloc/product/product_event.dart';

class ProductRepository {
  final LocalStorageService _localStorageService;
  final ApiService _apiService;
  late Box<Product> _productBox;

  ProductRepository({
    required LocalStorageService localStorageService,
    required ApiService apiService,
  }) : _localStorageService = localStorageService,
       _apiService = apiService {
    _productBox = _localStorageService.productBox;
  }

  Future<List<Product>> getAllProducts() async {
    try {
      // First try to get from local storage
      final localProducts = _productBox.values.toList();

      if (localProducts.isNotEmpty) {
        // Return cached products immediately
        _refreshProductsFromAPI(); // Refresh in background
        return localProducts;
      }

      // If no local data, try to fetch from API
      try {
        return await _fetchProductsFromAPI();
      } catch (e) {
        // If API fails, return sample products
        return await _getSampleProducts();
      }
    } catch (e) {
      // Fallback to sample products
      return await _getSampleProducts();
    }
  }

  Future<Product> getProductById(String productId) async {
    try {
      // First try local storage
      final localProduct = _productBox.get(productId);
      if (localProduct != null) {
        return localProduct;
      }

      // If not found locally, fetch from API
      final productData = await _apiService.getProduct(productId);
      final product = Product.fromJson(productData);
      await _productBox.put(productId, product);
      return product;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        return _productBox.values.toList();
      }

      final allProducts = _productBox.values.toList();
      return allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase()) ||
            product.brand.toLowerCase().contains(query.toLowerCase()) ||
            product.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final allProducts = _productBox.values.toList();
      return allProducts
          .where((product) => product.category == category)
          .toList();
    } catch (e) {
      throw Exception('Failed to filter products by category: $e');
    }
  }

  Future<List<Product>> sortProducts(
    List<Product> products,
    ProductSortOption sortOption,
  ) async {
    try {
      switch (sortOption) {
        case ProductSortOption.nameAsc:
          products.sort((a, b) => a.name.compareTo(b.name));
          break;
        case ProductSortOption.nameDesc:
          products.sort((a, b) => b.name.compareTo(a.name));
          break;
        case ProductSortOption.priceAsc:
          products.sort((a, b) => a.price.compareTo(b.price));
          break;
        case ProductSortOption.priceDesc:
          products.sort((a, b) => b.price.compareTo(a.price));
          break;
        case ProductSortOption.ratingDesc:
          products.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case ProductSortOption.newest:
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
      return products;
    } catch (e) {
      throw Exception('Failed to sort products: $e');
    }
  }

  Future<List<Product>> loadMoreProducts(int currentCount) async {
    try {
      // This would typically involve pagination from API
      // For now, we'll return empty list to indicate no more products
      return [];
    } catch (e) {
      throw Exception('Failed to load more products: $e');
    }
  }

  Future<void> _refreshProductsFromAPI() async {
    try {
      final products = await _fetchProductsFromAPI();
      // Update local storage with fresh data
      for (final product in products) {
        await _productBox.put(product.id, product);
      }
    } catch (e) {
      // Silently fail - we already have local data
      print('Failed to refresh products from API: $e');
    }
  }

  Future<List<Product>> _fetchProductsFromAPI() async {
    try {
      final response = await _apiService.getProducts();
      final products = response.map((json) => Product.fromJson(json)).toList();

      // Cache products locally
      for (final product in products) {
        await _productBox.put(product.id, product);
      }

      return products;
    } catch (e) {
      throw Exception('Failed to fetch products from API: $e');
    }
  }

  Future<void> clearCache() async {
    await _productBox.clear();
  }

  Future<List<Product>> _getSampleProducts() async {
    final sampleProducts = [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        description:
            'The latest iPhone with titanium design, A17 Pro chip, and advanced camera system.',
        price: 2099998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
        category: 'Electronics',
        brand: 'Apple',
        sku: 'IPH15PRO-128',
        inStock: true,
        stockQuantity: 25,
        rating: 4.8,
        reviewCount: 1247,
        tags: ['smartphone', 'apple', 'premium', 'camera'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        isBestSeller: true,
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24 Ultra',
        description:
            'Premium Android smartphone with S Pen, 200MP camera, and AI-powered features.',
        price: 2519998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
        category: 'Electronics',
        brand: 'Samsung',
        sku: 'SGS24U-256',
        inStock: true,
        stockQuantity: 18,
        rating: 4.7,
        reviewCount: 892,
        tags: ['smartphone', 'samsung', 'android', 's-pen'],
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        isBestSeller: false,
      ),
      Product(
        id: '3',
        name: 'MacBook Pro 16"',
        description:
            'Powerful laptop with M3 Pro chip, Liquid Retina XDR display, and all-day battery life.',
        price: 5249998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400',
        category: 'Electronics',
        brand: 'Apple',
        sku: 'MBP16-M3PRO',
        inStock: true,
        stockQuantity: 12,
        rating: 4.9,
        reviewCount: 567,
        tags: ['laptop', 'apple', 'macbook', 'professional'],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isBestSeller: false,
      ),
      Product(
        id: '4',
        name: 'Sony WH-1000XM5',
        description:
            'Industry-leading noise canceling wireless headphones with 30-hour battery life.',
        price: 839998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        category: 'Electronics',
        brand: 'Sony',
        sku: 'WH1000XM5-BLK',
        inStock: true,
        stockQuantity: 35,
        rating: 4.6,
        reviewCount: 2156,
        tags: ['headphones', 'wireless', 'noise-canceling', 'audio'],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        isBestSeller: false,
      ),
      Product(
        id: '5',
        name: 'Nike Air Max 270',
        description:
            'Comfortable running shoes with Max Air cushioning and breathable mesh upper.',
        price: 315000.00,
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        category: 'Fashion',
        brand: 'Nike',
        sku: 'AM270-BLK-10',
        inStock: true,
        stockQuantity: 50,
        rating: 4.4,
        reviewCount: 1834,
        tags: ['shoes', 'nike', 'running', 'sneakers'],
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        isBestSeller: false,
      ),
      Product(
        id: '6',
        name: 'Adidas Ultraboost 22',
        description:
            'High-performance running shoes with Boost midsole and Primeknit upper.',
        price: 378000.00,
        imageUrl:
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
        category: 'Fashion',
        brand: 'Adidas',
        sku: 'UB22-WHT-9',
        inStock: true,
        stockQuantity: 42,
        rating: 4.5,
        reviewCount: 967,
        tags: ['shoes', 'adidas', 'running', 'boost'],
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
        updatedAt: DateTime.now().subtract(const Duration(days: 6)),
        isBestSeller: false,
      ),
      Product(
        id: '7',
        name: 'Levi\'s 501 Original Jeans',
        description:
            'Classic straight-fit jeans made from 100% cotton denim with button fly.',
        price: 188998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
        category: 'Fashion',
        brand: 'Levi\'s',
        sku: '501-32-34',
        inStock: true,
        stockQuantity: 28,
        rating: 4.3,
        reviewCount: 1456,
        tags: ['jeans', 'denim', 'classic', 'casual'],
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        isBestSeller: false,
      ),
      Product(
        id: '8',
        name: 'Uniqlo Heattech T-Shirt',
        description:
            'Lightweight thermal t-shirt that generates heat to keep you warm in cold weather.',
        price: 41998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
        category: 'Fashion',
        brand: 'Uniqlo',
        sku: 'HT-TS-M-BLK',
        inStock: true,
        stockQuantity: 75,
        rating: 4.2,
        reviewCount: 892,
        tags: ['t-shirt', 'thermal', 'warm', 'casual'],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isBestSeller: false,
      ),
      Product(
        id: '9',
        name: 'KitchenAid Stand Mixer',
        description:
            'Professional-grade stand mixer with 5-quart bowl and 10-speed motor.',
        price: 797998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
        category: 'Home & Kitchen',
        brand: 'KitchenAid',
        sku: 'KSM150PS-BLK',
        inStock: true,
        stockQuantity: 15,
        rating: 4.8,
        reviewCount: 2341,
        tags: ['mixer', 'kitchen', 'baking', 'appliance'],
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
        isBestSeller: false,
      ),
      Product(
        id: '10',
        name: 'Dyson V15 Detect Vacuum',
        description:
            'Cordless vacuum with laser dust detection and 60-minute runtime.',
        price: 1574998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        category: 'Home & Kitchen',
        brand: 'Dyson',
        sku: 'V15-DETECT',
        inStock: true,
        stockQuantity: 8,
        rating: 4.7,
        reviewCount: 1876,
        tags: ['vacuum', 'cordless', 'cleaning', 'dyson'],
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isBestSeller: false,
      ),
      Product(
        id: '11',
        name: 'Instant Pot Duo 7-in-1',
        description:
            'Electric pressure cooker that replaces 7 kitchen appliances in one.',
        price: 209998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1585515656519-4a0b5b5b5b5b?w=400',
        category: 'Home & Kitchen',
        brand: 'Instant Pot',
        sku: 'IP-DUO60-6QT',
        inStock: true,
        stockQuantity: 30,
        rating: 4.6,
        reviewCount: 3245,
        tags: ['pressure-cooker', 'kitchen', 'cooking', 'appliance'],
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isBestSeller: false,
      ),
      Product(
        id: '12',
        name: 'Nespresso Vertuo Coffee Machine',
        description:
            'Single-serve coffee machine with 5 cup sizes and automatic capsule recognition.',
        price: 419998.00,
        imageUrl:
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
        category: 'Home & Kitchen',
        brand: 'Nespresso',
        sku: 'VERTUO-BLK',
        inStock: false,
        stockQuantity: 0,
        rating: 4.4,
        reviewCount: 1567,
        tags: ['coffee', 'machine', 'nespresso', 'single-serve'],
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isBestSeller: false,
      ),
    ];

    // Cache sample products locally
    for (final product in sampleProducts) {
      await _productBox.put(product.id, product);
    }

    return sampleProducts;
  }
}
