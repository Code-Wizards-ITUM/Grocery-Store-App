import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

class JsonService {
  static Future<List<Map<String, dynamic>>> loadProducts() async {
    try {
      final jsonString = await rootBundle.loadString('lib/utils/products.json');
      final jsonData = json.decode(jsonString);
      return List<Map<String, dynamic>>.from(jsonData);
    } catch (e) {
      log('Error loading products: $e');
      return [];
    }
  }
}
