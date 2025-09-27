import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class LoadProductById extends ProductEvent {
  final String productId;

  const LoadProductById(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterProductsByCategory extends ProductEvent {
  final String category;

  const FilterProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SortProducts extends ProductEvent {
  final ProductSortOption sortOption;

  const SortProducts(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

class ClearProductFilters extends ProductEvent {
  const ClearProductFilters();
}

class ShareProduct extends ProductEvent {
  final Product product;

  const ShareProduct(this.product);

  @override
  List<Object?> get props => [product];
}

enum ProductSortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  ratingDesc,
  newest,
}
