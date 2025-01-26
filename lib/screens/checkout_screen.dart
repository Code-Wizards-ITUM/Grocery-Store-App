import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.green[800] : Colors.green,
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
                    color: isDarkMode ? Colors.white : Colors.green.shade700,
                  ),
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  context: context,
                  controller: nameController,
                  label: "Receiver's Full Name",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  context: context,
                  controller: phoneController,
                  label: "Receiver's Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter phone number';
                    }
                    // Basic phone number validation
                    String pattern = r'^[0-9]{10}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value.trim())) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  context: context,
                  controller: addressController,
                  label: 'Address',
                  icon: Icons.home,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your address';
                    }
                    if (value.trim().length < 10) {
                      return 'Address must be at least 10 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        context: context,
                        controller: cityController,
                        label: 'City',
                        icon: Icons.location_city,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter city';
                          }
                          if (value.trim().length < 2) {
                            return 'City name too short';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextFormField(
                        context: context,
                        controller: postalCodeController,
                        label: 'Postal Code',
                        icon: Icons.markunread_mailbox,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter postal code';
                          }
                          // Basic postal code validation (5-6 digits)
                          String pattern = r'^[0-9]{5,6}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value.trim())) {
                            return 'Enter a valid postal code';
                          }
                          return null;
                        },
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
                    color: isDarkMode ? Colors.white : Colors.green.shade700,
                  ),
                ),
                SizedBox(height: 16),
                _buildOrderSummary(cartProvider, isDarkMode),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.green[700] : Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        prefixIcon: Icon(
          icon, 
          color: isDarkMode ? Colors.white : Colors.green,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white24 : Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white : Colors.green, 
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Total Items: ${cartProvider.itemCount}',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Total Amount: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.green[400] : Colors.green.shade700,
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