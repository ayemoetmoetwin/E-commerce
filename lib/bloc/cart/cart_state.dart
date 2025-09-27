import 'package:equatable/equatable.dart';
import '../../models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String? appliedCoupon;
  final double couponDiscount;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    this.appliedCoupon,
    this.couponDiscount = 0.0,
  });

  CartLoaded copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? discount,
    double? total,
    String? appliedCoupon,
    double? couponDiscount,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      couponDiscount: couponDiscount ?? this.couponDiscount,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [
    items,
    subtotal,
    tax,
    discount,
    total,
    appliedCoupon,
    couponDiscount,
  ];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
