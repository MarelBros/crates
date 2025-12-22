import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final fetchedProducts = await ApiService.getProducts();
    setState(() {
      products = fetchedProducts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (products.isEmpty) return Center(child: Text('Товары не найдены'));

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(p.name),
            subtitle: Text('Количество: ${p.quantity} | Код: ${p.productCode}'),
            trailing: Text('ID: ${p.productID}'),
          ),
        );
      },
    );
  }
}
