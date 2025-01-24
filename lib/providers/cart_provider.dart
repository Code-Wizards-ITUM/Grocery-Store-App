import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => {..._items};

  int get itemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  double get totalAmount {
    return _items.values
        .fold(0.0, (total, item) => total + (item.price * item.quantity));
  }

  void addItem(String id, String name, double price, int quantity,String image) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingItem) => CartItemModel(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + quantity,
          image:existingItem.image
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItemModel(
          id: id,
          name: name,
          price: price,
          quantity: quantity,
          image: image
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void increaseQuantity(String id) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingItem) => CartItemModel(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          image: existingItem.image
        ),
      );
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    if (_items.containsKey(id)) {
      final currentItem = _items[id]!;
      if (currentItem.quantity > 1) {
        _items.update(
          id,
          (existingItem) => CartItemModel(
            id: existingItem.id,
            name: existingItem.name,
            price: existingItem.price,
            quantity: existingItem.quantity - 1,
            image: existingItem.image
          ),
        );
      } else {
        _items.remove(id);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
