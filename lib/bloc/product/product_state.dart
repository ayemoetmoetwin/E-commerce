import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';
import 'product_event.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String? searchQuery;
  final String? selectedCategory;
  final ProductSortOption? sortOption;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery,
    this.selectedCategory,
    this.sortOption,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    String? selectedCategory,
    ProductSortOption? sortOption,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortOption: sortOption ?? this.sortOption,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    searchQuery,
    selectedCategory,
    sortOption,
    hasReachedMax,
    isLoadingMore,
  ];
}

class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
