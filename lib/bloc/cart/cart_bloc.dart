import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({required CartRepository cartRepository})
    : _cartRepository = cartRepository,
      super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
    on<CalculateTotal>(_onCalculateTotal);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(const CartLoading());
      final cartItems = await _cartRepository.getCartItems();
      final totals = await _cartRepository.calculateTotals(cartItems);

      emit(
        CartLoaded(
          items: cartItems,
          subtotal: totals['subtotal'] ?? 0.0,
          tax: totals['tax'] ?? 0.0,
          discount: totals['discount'] ?? 0.0,
          total: totals['total'] ?? 0.0,
          appliedCoupon: totals['appliedCoupon'],
          couponDiscount: totals['couponDiscount'] ?? 0.0,
        ),
      );
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.addToCart(event.product, event.quantity);

      // Reload cart to get updated state
      add(const LoadCart());
    } catch (e) {
      emit(CartError('Failed to add to cart: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.removeFromCart(event.productId);

      // Reload cart to get updated state
      add(const LoadCart());
    } catch (e) {
      emit(CartError('Failed to remove from cart: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.updateCartItemQuantity(
        event.productId,
        event.quantity,
      );

      // Reload cart to get updated state
      add(const LoadCart());
    } catch (e) {
      emit(CartError('Failed to update cart item: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.clearCart();

      // Reload cart to get updated state
      add(const LoadCart());
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<CartState> emit,
  ) async {
    try {
      final result = await _cartRepository.applyCoupon(event.couponCode);

      if (result['success'] == true) {
        // Reload cart to get updated state with coupon applied
        add(const LoadCart());
      } else {
        emit(CartError(result['message'] ?? 'Invalid coupon code'));
      }
    } catch (e) {
      emit(CartError('Failed to apply coupon: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveCoupon(
    RemoveCoupon event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.removeCoupon();

      // Reload cart to get updated state
      add(const LoadCart());
    } catch (e) {
      emit(CartError('Failed to remove coupon: ${e.toString()}'));
    }
  }

  Future<void> _onCalculateTotal(
    CalculateTotal event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;

      try {
        final totals = await _cartRepository.calculateTotals(
          currentState.items,
        );

        emit(
          currentState.copyWith(
            subtotal: totals['subtotal'] ?? 0.0,
            tax: totals['tax'] ?? 0.0,
            discount: totals['discount'] ?? 0.0,
            total: totals['total'] ?? 0.0,
            appliedCoupon: totals['appliedCoupon'],
            couponDiscount: totals['couponDiscount'] ?? 0.0,
          ),
        );
      } catch (e) {
        emit(CartError('Failed to calculate total: ${e.toString()}'));
      }
    }
  }
}
