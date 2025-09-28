import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../utils/helpers.dart';
import 'cart_screen.dart';
import '../utils/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppColors.secondary,
        actions: [
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              context.read<ProductBloc>().add(ShareProduct(widget.product));
            },
          ),
          // Favorite button
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFavorite =
                  state is FavoritesLoaded &&
                  state.isFavorite(widget.product.id);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.favorite : null,
                ),
                onPressed: () {
                  context.read<FavoritesBloc>().add(
                    ToggleFavorite(widget.product),
                  );
                },
              );
            },
          ),
          // Cart button
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductInfo(),
            _buildProductDescription(),
            _buildQuantitySelector(),
            _buildAddToCartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 300,
      width: double.infinity,
      color: AppColors.iconGreyLight,
      child: widget.product.imageUrl.isNotEmpty
          ? Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: AppColors.iconGrey,
                  ),
                );
              },
            )
          : const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 100,
                color: AppColors.iconGrey,
              ),
            ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${widget.product.price.toStringAsFixed(0)} MMK',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.product.inStock ? AppColors.textGreen : AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.product.inStock ? 'In Stock' : 'Out of Stock',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.rating, size: 20),
              const SizedBox(width: 4),
              Text(
                '4.5', // This would come from product rating
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 8),
              Text(
                '(128 reviews)', // This would come from product reviews
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.iconGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          // Additional product details
          _buildDetailRow('Category', widget.product.category),
          _buildDetailRow('Brand', widget.product.brand),
          _buildDetailRow('SKU', widget.product.sku),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Quantity:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Container(
            height:40,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.iconGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    quantity.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => quantity++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: widget.product.inStock
              ? () {
                  context.read<CartBloc>().add(
                    AddToCart(product: widget.product, quantity: quantity),
                  );

                  AppHelpers.showSuccessSnackBar(
                    context,
                    '${widget.product.name} (x$quantity) added to cart',
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.product.inStock ? AppColors.primary : AppColors.iconGrey,
            foregroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.product.inStock ? 'Add to Cart' : 'Out of Stock',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
