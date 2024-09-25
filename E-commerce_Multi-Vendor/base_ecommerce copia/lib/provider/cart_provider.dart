import 'package:base_ecommerce/models/cart_attributes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double get totalPrice{
    var total = 0.0;
    _cartItems.forEach((key, value) { 
      total += value.price * value.quantity;
    });
    return total;
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrlList,
    int quantity,
    int productQuantity,
    double price,
    String vendorId,
    String productSize,
    Timestamp scheduleDate,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCart) => CartAttr(
              productName: existingCart.productName,
              productId: existingCart.productId,
              imageUrlList: existingCart.imageUrlList,
              quantity: existingCart.quantity + 1,
              productQuantity: existingCart.productQuantity,
              price: existingCart.price,
              vendorId: existingCart.vendorId,
              productSize: existingCart.productSize,
              scheduleDate: existingCart.scheduleDate));

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
              productName: productName,
              productId: productId,
              imageUrlList: imageUrlList,
              quantity: quantity,
              productQuantity: productQuantity,
              price: price,
              vendorId: vendorId,
              productSize: productSize,
              scheduleDate: scheduleDate));

      notifyListeners();
    }
  }

  void increament(CartAttr cartAttr){
    cartAttr.increase();
    notifyListeners();
  }

  void decreament(CartAttr cartAttr){
    cartAttr.decrease();
    notifyListeners();
  }

  void removeItem(productId){
    _cartItems.remove(productId);

    notifyListeners();
  }

  void removeAllItems(){
    _cartItems.clear();
    notifyListeners();
  }
}
