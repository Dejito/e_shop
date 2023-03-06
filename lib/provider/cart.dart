import 'package:flutter/material.dart';

class CartItemz {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItemz({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {

  final Map<String, CartItemz> _items = { };

  Map<String, CartItemz> get items {
    return {..._items};
  }

  void addItem (productId, price, title) {
    if (_items.containsKey(productId)){
      _items.update(productId, (existingCartItem) {
        return CartItemz(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity+1,
            price: existingCartItem.price * 2
        );
      });
    } else {
      _items.putIfAbsent(productId, () =>
      CartItemz(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price)
      );
    }
    notifyListeners();
  }

  int get cartItemsFigure {
    return _items.length;
  }

  double get totalAmount  {
    double totalAmount = 0;
    _items.forEach((key, cartItems) {
      totalAmount += cartItems.quantity * cartItems.price;
    });
    return totalAmount;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void emptyCart() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if(!_items.containsKey(productID)){
      return;
    }
     if (_items[productID]!.quantity > 1) {
       _items.update(productID, (existingCartItem) {
         return CartItemz(
             id: existingCartItem.id,
             title: existingCartItem.title,
             quantity: existingCartItem.quantity - 1,
             price: existingCartItem.price
         );
       });
     } else {
       _items.remove(productID);
     }
     notifyListeners();
  }

  }