import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Get orders for the currently logged-in user
    final userOrders = userProvider.currentUser != null
        ? orderProvider.getOrdersForUser(userProvider.currentUser!.id)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.green[800] : Colors.green,
      ),
      body: userOrders.isEmpty
          ? Center(
              child: Text(
                'No orders yet',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black,
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              itemCount: userOrders.length,
              itemBuilder: (ctx, i) => OrderItem(userOrders[i]),
            ),
    );
  }
}
