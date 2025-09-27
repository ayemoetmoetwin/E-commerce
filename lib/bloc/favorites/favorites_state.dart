import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<Product> favoriteProducts;
  final Set<String> favoriteProductIds;

  const FavoritesLoaded({
    required this.favoriteProducts,
    required this.favoriteProductIds,
  });

  FavoritesLoaded copyWith({
    List<Product>? favoriteProducts,
    Set<String>? favoriteProductIds,
  }) {
    return FavoritesLoaded(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    );
  }

  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }

  int get count => favoriteProducts.length;

  bool get isEmpty => favoriteProducts.isEmpty;

  @override
  List<Object?> get props => [favoriteProducts, favoriteProductIds];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
