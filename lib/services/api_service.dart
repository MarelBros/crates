import 'dart:convert';
import 'package:crates/models/transaction.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/product_create.dart';
import '../models/supplier.dart';
import '../models/warehouse.dart';

class ApiService {
  static const String baseUrl = 'http://85.15.176.78:5000/api';

  ////////////////////////////////////////////////// PRODUCTS

  static Future<List<Product>> getProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products'));

    if (res.statusCode != 200) return [];

    final List data = json.decode(res.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }

  static Future<bool> createProduct(ProductCreate dto) async {
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<bool> updateProduct(int id, ProductCreate dto) async {
    final res = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    return res.statusCode == 204 || res.statusCode == 200;
  }

  static Future<bool> deleteProduct(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
    );

    return res.statusCode == 204 || res.statusCode == 200;
  }

 //////////////////////////////////////////////// TRANSACTIONS
static Future<List<TransactionModel>> getTransactions() async {
  final res = await http.get(Uri.parse('$baseUrl/transactions'));
  if (res.statusCode != 200) return [];

  final List data = json.decode(res.body);
  return data.map((e) => TransactionModel.fromJson(e)).toList();
}

static Future<bool> createTransaction(Map<String, dynamic> data) async {
  final res = await http.post(
    Uri.parse('$baseUrl/transactions'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  return res.statusCode == 201;
}

static Future<bool> updateTransaction(int id, Map<String, dynamic> data) async {
  final res = await http.put(
    Uri.parse('$baseUrl/transactions/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  return res.statusCode == 204;
}

static Future<bool> deleteTransaction(int id) async {
  final res = await http.delete(Uri.parse('$baseUrl/transactions/$id'));
  return res.statusCode == 204;
}

  ////////////////////////////////////////////////// SUPPLIERS

  static Future<List<Supplier>> getSuppliers() async {
    final res = await http.get(Uri.parse('$baseUrl/suppliers'));

    if (res.statusCode != 200) return [];

    final List data = json.decode(res.body);
    return data.map((e) => Supplier.fromJson(e)).toList();
  }

  static Future<bool> createSupplier({
    required String name,
    required String inn,
    String? phone,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/suppliers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'inn': inn,
        'phone': phone,
      }),
    );

    return res.statusCode == 201 || res.statusCode == 200;
  }

  static Future<bool> updateSupplier(int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/suppliers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return res.statusCode == 204 || res.statusCode == 200;
  }

  static Future<bool> deleteSupplier(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/suppliers/$id'),
    );

    return res.statusCode == 204 || res.statusCode == 200;
  }

  //////////////////////////////////////////////////////////////

  //////////////////////////////////////////////// WAREHOUSES

static Future<List<Warehouse>> getWarehouses() async {
  final res = await http.get(Uri.parse('$baseUrl/warehouses'));
  if (res.statusCode != 200) return [];

  final List data = json.decode(res.body);
  return data.map((e) => Warehouse.fromJson(e)).toList();
}

static Future<bool> createWarehouse(String name) async {
  final res = await http.post(
    Uri.parse('$baseUrl/warehouses'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name}),
  );
  return res.statusCode == 201 || res.statusCode == 200;
}

static Future<bool> updateWarehouse(int id, String name) async {
  final res = await http.put(
    Uri.parse('$baseUrl/warehouses/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name}),
  );
  return res.statusCode == 204 || res.statusCode == 200;
}

static Future<bool> deleteWarehouse(int id) async {
  final res = await http.delete(
    Uri.parse('$baseUrl/warehouses/$id'),
  );
  return res.statusCode == 204 || res.statusCode == 200;
}
}