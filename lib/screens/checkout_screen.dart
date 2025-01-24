import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  String generateOrderId() {
    DateTime now = DateTime.now();
    return "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-"
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}"
        "${now.second.toString().padLeft(2, '0')}-${now.millisecond}";
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill user details if logged in
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      nameController.text = userProvider.currentUser!.name;
      phoneController.text = userProvider.currentUser!.phone;
      emailController.text = userProvider.currentUser!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Shipping Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  controller: nameController,
                  label: "Receiver's Full Name",
                  icon: Icons.person,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  controller: phoneController,
                  label: "Receiver's Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter phone number' : null,
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  controller: addressController,
                  label: 'Address',
                  icon: Icons.home,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your address' : null,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        controller: cityController,
                        label: 'City',
                        icon: Icons.location_city,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter city' : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextFormField(
                        controller: postalCodeController,
                        label: 'Postal Code',
                        icon: Icons.markunread_mailbox,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter postal code' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                SizedBox(height: 16),
                _buildOrderSummary(cartProvider),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Total Items: ${cartProvider.itemCount}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Total Amount: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      final cartDetails = cartProvider.items.values.map((item) {
        return {
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
        };
      }).toList();

      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

      try {
        final order = Order(
          orderId: generateOrderId(),
          userId: userProvider.currentUser!.id,
          placedUserName: userProvider.currentUser!.name,
          date: formattedDate,
          receiverName: nameController.text.trim(),
          address:
              '${addressController.text.trim()}, ${cityController.text.trim()} ${postalCodeController.text.trim()}',
          phone: phoneController.text.trim(),
          totalValue: cartProvider.totalAmount,
          numberOfItems: cartProvider.itemCount,
          cartItems: List<Map<String, dynamic>>.from(cartDetails),
        );

        orderProvider.addOrder(order);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order Placed Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        cartProvider.clear();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Failed to place order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }
}
