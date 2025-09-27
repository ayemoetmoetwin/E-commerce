import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddToFavorites extends FavoritesEvent {
  final Product product;

  const AddToFavorites(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String productId;

  const RemoveFromFavorites(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ToggleFavorite extends FavoritesEvent {
  final Product product;

  const ToggleFavorite(this.product);

  @override
  List<Object?> get props => [product];
}

class ClearFavorites extends FavoritesEvent {
  const ClearFavorites();
}

class CheckIfFavorite extends FavoritesEvent {
  final String productId;

  const CheckIfFavorite(this.productId);

  @override
  List<Object?> get props => [productId];
}
