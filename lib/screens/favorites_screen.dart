import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../widgets/product_card.dart';
import '../utils/colors.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoaded &&
                  state.favoriteProducts.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    _showClearFavoritesDialog(context);
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: AppColors.favorite),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            if (state.favoriteProducts.isEmpty) {
              return _buildEmptyFavorites();
            }
            return _buildFavoritesList(state.favoriteProducts);
          } else if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.favoritelight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading favorites',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesBloc>().add(const LoadFavorites());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return _buildEmptyFavorites();
        },
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: AppColors.iconGrey),
          SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.iconGrey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add products to your favorites to see them here',
            style: TextStyle(fontSize: 16, color: AppColors.iconGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<dynamic> favoriteProducts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: VerticalProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Favorites'),
          content: const Text(
            'Are you sure you want to remove all products from your favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoritesBloc>().add(const ClearFavorites());
                Navigator.of(context).pop();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: AppColors.favorite),
              ),
            ),
          ],
        );
      },
    );
  }
}
