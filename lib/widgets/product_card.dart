import 'package:flutter/material.dart';
import 'package:grocery_store_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  ProductCard(this.product);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 1;
  final _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      Provider.of<CartProvider>(context, listen: false).addItem(
          widget.product['id'].toString(),
          widget.product['name'],
          widget.product['price'],
          _quantity,
          widget.product['image']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart')),
      );
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
      _quantityController.text = _quantity.toString();
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = _quantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        height: 260,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 90,
              child: Image.asset(
                'assets/images/${widget.product['image']}',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              widget.product['name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\$${widget.product['price'].toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(Icons.remove, _decreaseQuantity),
                Container(
                  width: 32,
                  height: 32,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _quantityController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    style: TextStyle(fontSize: 14),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        setState(() {
                          _quantity = int.parse(value);
                        });
                      }
                    },
                  ),
                ),
                _buildIconButton(Icons.add, _increaseQuantity),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(4),
        child: Icon(icon, color: Colors.green, size: 20),
      ),
    );
  }
}
