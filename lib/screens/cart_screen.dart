import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/checkout_screen.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.green[800] : Colors.green,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            elevation: 4,
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.green.shade900.withOpacity(0.5)
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.green.shade300
                            : Colors.green.shade700,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: cart.itemCount <= 0
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CheckoutScreen()));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.green[700] : Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CHECKOUT',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white70 : Colors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      var item = cart.items.values.toList()[i];
                      return CartItemWidget(
                        cartItem: item,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
