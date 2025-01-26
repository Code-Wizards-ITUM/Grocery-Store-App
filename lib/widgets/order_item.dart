import 'package:flutter/material.dart';
import '../providers/order_provider.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          'Order ID: ${order.orderId}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.green.shade300 : Colors.green.shade700,
          ),
        ),
        subtitle: Text(
          'Date: ${order.date}',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
          ),
        ),
        trailing: Text(
          '\$${order.totalValue.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.green.shade300 : Colors.green.shade900,
            fontSize: 16,
          ),
        ),
        onTap: () => _showOrderDetails(context),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
        title: Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.green.shade300 : Colors.green.shade800,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Order ID', order.orderId, isDarkMode),
              _buildDetailRow('Date', order.date, isDarkMode),
              _buildDetailRow('User Name', order.placedUserName, isDarkMode),
              _buildDetailRow('Receiver Name', order.receiverName, isDarkMode),
              _buildDetailRow('Receiver Contact No', order.phone, isDarkMode),
              _buildDetailRow('Delivery Address', order.address, isDarkMode),
              _buildDetailRow(
                  'Total', '\$${order.totalValue.toStringAsFixed(2)}', isDarkMode),
              SizedBox(height: 10),
              Text(
                'Items:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.green.shade300 : Colors.green.shade700,
                ),
              ),
              ...order.cartItems.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${item['name']} - Qty: ${item['quantity']} - \$${item['price']}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: isDarkMode ? Colors.green.shade300 : Colors.green.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.green.shade300 : Colors.green.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}