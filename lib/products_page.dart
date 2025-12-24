import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/add_product_dialog.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  bool isLoading = true;

  void fetchProducts() async {
    setState(() => isLoading = true);
    products = await ApiService.getProducts();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddProductDialog(onSuccess: fetchProducts),
          );
        },
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) {
                final p = products[i];
                return Card(
                  child: ListTile(
                    title: Text(p.name),
                    subtitle: Text('Кол-во: ${p.quantity} | Код: ${p.productCode}'),
                    trailing: Text('#${p.productID}'),
                  ),
                );
              },
            ),
    );
  }
}