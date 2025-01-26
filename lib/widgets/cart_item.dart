import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../models/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  CartItemWidget({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmRemoval(context),
      onDismissed: (direction) {
        cartProvider.removeItem(cartItem.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.name} removed from cart'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/${cartItem.image}',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Price: \$${cartItem.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            isDarkMode ? Colors.white70 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: isDarkMode ? Colors.red.shade300 : Colors.red,
                        ),
                        onPressed: cartItem.quantity > 1
                            ? () => cartProvider.decreaseQuantity(cartItem.id)
                            : null,
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color:
                              isDarkMode ? Colors.green.shade300 : Colors.green,
                        ),
                        onPressed: () =>
                            cartProvider.increaseQuantity(cartItem.id),
                      ),
                    ],
                  ),
                  Text(
                    'Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Colors.green.shade300
                          : Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmRemoval(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Remove Item',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          'Do you want to remove ${cartItem.name} from the cart?',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
