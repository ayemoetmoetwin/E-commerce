import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../utils/colors.dart';
import '../widgets/button_widget.dart';

class VerticalProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool showShareButton;
  final bool showAddToCartButton;

  const VerticalProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showFavoriteButton = true,
    this.showShareButton = true,
    this.showAddToCartButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.defaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildProductImage(context), _buildProductInfo(context)],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.defaultBorderRadius),
            ),
            color: AppColors.iconGreyLight,
          ),
          child: product.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.defaultBorderRadius),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.iconGrey,
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: AppColors.iconGrey,
                  ),
                ),
        ),
        // Top action buttons
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showShareButton) _buildShareButton(context),
              if (showFavoriteButton) _buildFavoriteButton(context),
            ],
          ),
        ),
        if (!product.inStock)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.favorite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Out of Stock',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (product.rating > 0)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: AppColors.rating, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return ShareButtonWidget(
      onPressed: () {
        context.read<ProductBloc>().add(ShareProduct(product));
      },
      iconColor: AppColors.primary,
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return FavoriteButton(product: product, iconSize: 18, buttonSize: 32);
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Product description
          Text(
            product.description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.iconGrey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                product.price.currency,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (product.rating > 0) ...[
                Icon(Icons.star, color: AppColors.rating, size: 16),
                const SizedBox(width: 4),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 4),
                Text(
                  '(${product.reviewCount})',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.iconGrey),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          if (showAddToCartButton) _buildAddToCartButton(context),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: product.inStock
            ? () {
                context.read<CartBloc>().add(
                  AddToCart(product: product, quantity: 1),
                );
                AppHelpers.showSuccessSnackBar(
                  context,
                  '${product.name} added to cart',
                );
              }
            : null,
        icon: const Icon(Icons.add_shopping_cart, size: 18),
        label: Text(
          product.inStock ? 'Add to Cart' : 'Out of Stock',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: product.inStock
              ? AppColors.primary
              : AppColors.iconGrey,
          foregroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}

class GridProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool showShareButton;
  final bool showAddToCartButton;

  const GridProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showFavoriteButton = true,
    this.showShareButton = true,
    this.showAddToCartButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondary,
      elevation: AppConstants.smallElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildProductImage(context), _buildProductInfo(context)],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.defaultBorderRadius),
            ),
            color: AppColors.iconGreyLight,
          ),
          child: product.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.defaultBorderRadius),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: AppColors.iconGrey,
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 30,
                    color: AppColors.iconGrey,
                  ),
                ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showShareButton) _buildShareButton(context),
              if (showFavoriteButton) _buildFavoriteButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return ShareButtonWidget(
      onPressed: () {
        context.read<ProductBloc>().add(ShareProduct(product));
      },
      iconColor: AppColors.primary,
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return FavoriteButton(product: product, iconSize: 20, buttonSize: 20);
  }

  Widget _buildProductInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((product.isBestSeller ?? false) || product.rating > 4.5)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'BEST SELLER',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.iconGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 33.6, // Fixed height for 2 lines (14 * 1.2 * 2)
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Text(
                    product.price.currency,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.iconGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (showAddToCartButton)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          if (product.inStock) {
                            context.read<CartBloc>().add(
                              AddToCart(product: product, quantity: 1),
                            );
                            AppHelpers.showSuccessSnackBar(
                              context,
                              '${product.name} added to cart',
                            );
                          } else {
                            AppHelpers.showErrorSnackBar(
                              context,
                              '${product.name} is out of stock',
                            );
                          }
                        },
                        child: Center(
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: product.inStock
                                ? AppColors.secondary
                                : AppColors.iconGrey,
                            size: 22,
                            weight: 600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
