// import 'package:flutter/material.dart';
// import '../providers/order_provider.dart';

// class OrderItem extends StatelessWidget {
//   final Order order;

//   OrderItem(this.order);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10),
//       child: ListTile(
//         title: Text('Order ID: ${order.orderId}'),
//         subtitle: Text('Date: ${order.date}'),
//         trailing: Text('\$${order.totalValue.toStringAsFixed(2)}'),
//         onTap: () {
//           _showOrderDetails(context);
//         },
//       ),
//     );
//   }

//   void _showOrderDetails(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Order Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Order ID: ${order.orderId}'),
//               Text('Date: ${order.date}'),
//               Text('User Name: ${order.userId}'),
//               Text('Receiver Name: ${order.personName}'),
//               Text('Delivery address: ${order.address}'),
//               Text('Total: \$${order.totalValue.toStringAsFixed(2)}'),
//               SizedBox(height: 10),
//               Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
//               ...order.cartItems.map((item) => Text(
//                     '${item['name']} - Qty: ${item['quantity']} - \$${item['price']}',
//                   )),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../providers/order_provider.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          'Order ID: ${order.orderId}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        subtitle: Text(
          'Date: ${order.date}',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Text(
          '\$${order.totalValue.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
            fontSize: 16,
          ),
        ),
        onTap: () => _showOrderDetails(context),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Order ID', order.orderId),
              _buildDetailRow('Date', order.date),
              _buildDetailRow('User Name', order.placedUserName),
              _buildDetailRow('Receiver Name', order.receiverName),
              _buildDetailRow('Receiver Contact No', order.phone),
              _buildDetailRow('Delivery Address', order.address),
              _buildDetailRow(
                  'Total', '\$${order.totalValue.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text(
                'Items:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              ...order.cartItems.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${item['name']} - Qty: ${item['quantity']} - \$${item['price']}',
                      style: TextStyle(color: Colors.grey.shade700),
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
              style: TextStyle(color: Colors.green.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
