import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:grocery_store_app/services/json_service.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final categories = [
    'All',
    'Fruits',
    'Vegetables',
    'Meat & Seafood',
    'Snacks',
    'Dairy'
  ];
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final productData = await JsonService.loadProducts();
    setState(() {
      products = productData;
      filteredProducts = productData;
    });
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((p) {
        final name = p['name']?.toString() ?? '';
        final category = p['category']?.toString() ?? '';
        return name.toLowerCase().contains(query.toLowerCase()) &&
            (_selectedCategory == 'All' || category == _selectedCategory);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
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
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white : Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white24 : Colors.grey,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: filterProducts,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (_, index) {
                final category = categories[index];
                return FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
                      filterProducts('');
                    });
                  },
                  backgroundColor:
                      isDarkMode ? Colors.grey[700] : Colors.grey[200],
                  selectedColor: isDarkMode ? Colors.green[700] : Colors.green,
                  labelStyle: TextStyle(
                    color: _selectedCategory == category
                        ? Colors.white
                        : (isDarkMode ? Colors.white70 : Colors.black),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (_, i) => ProductCard(filteredProducts[i]),
            ),
          ),
        ],
      ),
    );
  }
}
