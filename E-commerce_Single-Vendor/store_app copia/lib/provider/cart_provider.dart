import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/models/cart_models.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
  (ref) {
    return CartNotifier();
  },
);

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});
  void addProductToCart({
    required String productName,
    required double productPrice,
    required String categoryName,
    required List imageUrl,
    required int quantity,
    required int instock,
    required String productId,
    required String productSize,
    required double discount,
    required String description,
  }) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: CartModel(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          categoryName: state[productId]!.categoryName,
          imageUrl: state[productId]!.imageUrl,
          quantity: state[productId]!.quantity + 1,
          instock: state[productId]!.instock,
          productId: state[productId]!.productId,
          productSize: state[productId]!.productSize,
          discount: state[productId]!.discount,
          description: state[productId]!.description,
        ),
      };
    } else {
      state = {
        ...state,
        productId: CartModel(
          productName: productName,
          productPrice: productPrice,
          categoryName: categoryName,
          imageUrl: imageUrl,
          quantity: quantity,
          instock: instock,
          productId: productId,
          productSize: productSize,
          discount: discount,
          description: description,
        )
      };
    }
  }
  //function to remove element to cart
  void removeItem(String productId){
    state.remove(productId);
    //notify listeners that state has changed
    state = {...state};
  }

  //function to increment cart item
  void incrementItem(String productId){
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;
    }
    //notify listener that state has changed
    state = {...state};
  }

  //function to decrement cart item
  void decrementItem(String productId){
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;
    }
    //notify listener that state has changed
    state = {...state};
  }

  // void clearCartData(){
  //   state.clear();
  //   //notify listener that state has changed
  //   state = {...state};
  // }

  double calculateTotalAmount(){
    double totalAmount = 0.0;
    state.forEach((productId, cartItem){
      totalAmount += cartItem.quantity * (cartItem.productPrice - cartItem.discount);
    });
    return totalAmount;
  }

  Map<String, CartModel> get getCartItem => state;
}
