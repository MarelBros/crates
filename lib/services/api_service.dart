import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/product_create.dart';
import '../models/supplier.dart';
import '../models/warehouse.dart';

class ApiService {
  static const String baseUrl = 'http://85.15.176.78:5000/api';

 static Future<List<Product>> getProducts() async {
  try {
    final res = await http.get(Uri.parse('$baseUrl/products'));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      print('HTTP ошибка: ${res.statusCode}');
      return [];
    }
  } catch (e) {
    print('СЕТЕВАЯ ОШИБКА: $e');
    return [];
  }
}


  static Future<List<Supplier>> getSuppliers() async {
    final res = await http.get(Uri.parse('$baseUrl/suppliers'));
    final List data = json.decode(res.body);
    return data.map((e) => Supplier.fromJson(e)).toList();
  }

  static Future<List<Warehouse>> getWarehouses() async {
    final res = await http.get(Uri.parse('$baseUrl/warehouses'));
    final List data = json.decode(res.body);
    return data.map((e) => Warehouse.fromJson(e)).toList();
  }

  static Future<bool> createProduct(ProductCreate dto) async {
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );
    return res.statusCode == 201;
  }
}