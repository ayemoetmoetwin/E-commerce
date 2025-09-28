import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsByCategory>(_onFilterProductsByCategory);
    on<SortProducts>(_onSortProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<ClearProductFilters>(_onClearProductFilters);
    on<ShareProduct>(_onShareProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(const ProductLoading());
      final products = await _productRepository.getAllProducts();
      emit(ProductLoaded(products: products, filteredProducts: products));
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  Future<void> _onLoadProductById(
    LoadProductById event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(const ProductLoading());
      final product = await _productRepository.getProductById(event.productId);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductError('Failed to load product: ${e.toString()}'));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      try {
        final filteredProducts = await _productRepository.searchProducts(
          event.query,
        );
        emit(
          currentState.copyWith(
            filteredProducts: filteredProducts,
            searchQuery: event.query,
          ),
        );
      } catch (e) {
        emit(ProductError('Failed to search products: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterProductsByCategory(
    FilterProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      try {
        final filteredProducts = await _productRepository.getProductsByCategory(
          event.category,
        );
        emit(
          currentState.copyWith(
            filteredProducts: filteredProducts,
            selectedCategory: event.category,
          ),
        );
      } catch (e) {
        emit(ProductError('Failed to filter products: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSortProducts(
    SortProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      try {
        final sortedProducts = await _productRepository.sortProducts(
          currentState.filteredProducts,
          event.sortOption,
        );
        emit(
          currentState.copyWith(
            filteredProducts: sortedProducts,
            sortOption: event.sortOption,
          ),
        );
      } catch (e) {
        emit(ProductError('Failed to sort products: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final products = await _productRepository.getAllProducts();
      emit(ProductLoaded(products: products, filteredProducts: products));
    } catch (e) {
      emit(ProductError('Failed to refresh products: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      if (currentState.isLoadingMore || currentState.hasReachedMax) {
        return;
      }

      try {
        emit(currentState.copyWith(isLoadingMore: true));

        final moreProducts = await _productRepository.loadMoreProducts(
          currentState.products.length,
        );

        if (moreProducts.isEmpty) {
          emit(
            currentState.copyWith(hasReachedMax: true, isLoadingMore: false),
          );
        } else {
          final allProducts = [...currentState.products, ...moreProducts];
          emit(
            currentState.copyWith(
              products: allProducts,
              filteredProducts: allProducts,
              isLoadingMore: false,
            ),
          );
        }
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
        emit(ProductError('Failed to load more products: ${e.toString()}'));
      }
    }
  }

  Future<void> _onClearProductFilters(
    ClearProductFilters event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(
        currentState.copyWith(
          filteredProducts: currentState.products,
          searchQuery: null,
          selectedCategory: null,
          sortOption: null,
        ),
      );
    }
  }

  Future<void> _onShareProduct(
    ShareProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final shareText =
          '''
🛍️ ${event.product.name}

💰 Price: \$${event.product.price.toStringAsFixed(2)}
⭐ Rating: ${event.product.rating}/5 (${event.product.reviewCount} reviews)

📝 ${event.product.description}

🏷️ Category: ${event.product.category}
🏪 Brand: ${event.product.brand}

Check out this amazing product in our ecommerce app! 🛒

#Shopping #Ecommerce #${event.product.category} #${event.product.brand}
''';

      // Share with subject and proper formatting
      await Share.share(
        shareText,
        subject:
            '${event.product.name} - \$${event.product.price.toStringAsFixed(2)}',
      );
    } catch (e) {
      // Handle share error silently
    }
  }
}
