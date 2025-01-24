import 'package:flutter/material.dart';

class Order {
  final String orderId;
  final String userId; // Add user ID to track orders
  final String placedUserName;
  final String date;
  final String receiverName;
  final String address;
  final String phone;
  final double totalValue;
  final int numberOfItems;
  final List<Map<String, dynamic>> cartItems;

  Order({
    required this.orderId,
    required this.userId,
    required this.placedUserName,
    required this.date,
    required this.receiverName,
    required this.address,
    required this.phone,
    required this.totalValue,
    required this.numberOfItems,
    required this.cartItems,
  });
}

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  // Get orders for the specific user
  List<Order> getOrdersForUser(String userId) {
    return _orders.where((order) => order.userId == userId).toList();
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  List<Order> get orders => List.unmodifiable(_orders);
}
