import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../utils/colors.dart';

class ShareButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Color iconColor;

  const ShareButtonWidget({
    super.key,
    required this.onPressed,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.7),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.share, color: iconColor),
        iconSize: 20,
        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final Product product;
  final double iconSize;
  final double buttonSize;

  const FavoriteButton({
    super.key,
    required this.product,
    this.iconSize = 18,
    this.buttonSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite =
            state is FavoritesLoaded && state.isFavorite(product.id);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              context.read<FavoritesBloc>().add(ToggleFavorite(product));
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.favorite : AppColors.iconGrey,
            ),
            iconSize: iconSize,
            constraints: BoxConstraints(
              minWidth: buttonSize,
              minHeight: buttonSize,
            ),
          ),
        );
      },
    );
  }
}
