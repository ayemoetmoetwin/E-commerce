import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc({required FavoritesRepository favoritesRepository})
    : _favoritesRepository = favoritesRepository,
      super(const FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ClearFavorites>(_onClearFavorites);
    on<CheckIfFavorite>(_onCheckIfFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(const FavoritesLoading());
      final favoriteProducts = await _favoritesRepository.getFavoriteProducts();
      final favoriteProductIds = favoriteProducts.map((p) => p.id).toSet();

      emit(
        FavoritesLoaded(
          favoriteProducts: favoriteProducts,
          favoriteProductIds: favoriteProductIds,
        ),
      );
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: ${e.toString()}'));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.addToFavorites(event.product);

      // Reload favorites to get updated state
      add(const LoadFavorites());
    } catch (e) {
      emit(FavoritesError('Failed to add to favorites: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.removeFromFavorites(event.productId);

      // Reload favorites to get updated state
      add(const LoadFavorites());
    } catch (e) {
      emit(FavoritesError('Failed to remove from favorites: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isCurrentlyFavorite = await _favoritesRepository.isFavorite(
        event.product.id,
      );

      if (isCurrentlyFavorite) {
        await _favoritesRepository.removeFromFavorites(event.product.id);
      } else {
        await _favoritesRepository.addToFavorites(event.product);
      }

      // Reload favorites to get updated state
      add(const LoadFavorites());
    } catch (e) {
      emit(FavoritesError('Failed to toggle favorite: ${e.toString()}'));
    }
  }

  Future<void> _onClearFavorites(
    ClearFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.clearFavorites();

      // Reload favorites to get updated state
      add(const LoadFavorites());
    } catch (e) {
      emit(FavoritesError('Failed to clear favorites: ${e.toString()}'));
    }
  }

  Future<void> _onCheckIfFavorite(
    CheckIfFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      // Check if product is favorite
      currentState.isFavorite(event.productId);

      // You might want to emit a different state here or handle this differently
      // For now, we'll just keep the current state
      emit(currentState);
    }
  }
}
