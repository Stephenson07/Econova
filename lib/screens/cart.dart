import 'package:flutter/material.dart';
import 'store_screen.dart'; // For the Product class

class Cart extends ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product product) {
    _items.add(product);
    // You could use ChangeNotifier for state management if needed
    // notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    // notifyListeners();
  }

  void clearCart() {
    _items = [];
    // notifyListeners();
  }

  double get totalAmount {
    return _items.fold(
      0,
      (previousValue, product) => previousValue + product.price,
    );
  }
}
