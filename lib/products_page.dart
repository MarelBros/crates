import 'package:crates/widgets/edit_product_dialog.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/warehouse.dart';
import '../services/api_service.dart';
import '../widgets/add_product_dialog.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  List<Warehouse> warehouses = [];
  Warehouse? selectedWarehouse;
  bool isLoading = true;

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    List<Product> allProducts = await ApiService.getProducts();
    if (selectedWarehouse != null) {
      products = allProducts
          .where((p) => p.warehouse == selectedWarehouse!.name)
          .toList();
    } else {
      products = allProducts;
    }
    setState(() => isLoading = false);
  }

  Future<void> fetchWarehouses() async {
    warehouses = await ApiService.getWarehouses();
  }

  @override
  void initState() {
    super.initState();
    fetchWarehouses().then((_) => fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => AddProductDialog(),
          );

          if (result == true) {
            fetchProducts();
          }
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<Warehouse>(
                    isExpanded: true,
                    hint: const Text('Выберите склад'),
                    value: selectedWarehouse,
                    items: [
                      const DropdownMenuItem<Warehouse>(
                        value: null,
                        child: Text('Все'),
                      ),
                      ...warehouses.map(
                        (w) => DropdownMenuItem(
                          value: w,
                          child: Text(w.name),
                        ),
                      ),
                    ],
                    onChanged: (w) {
                      setState(() {
                        selectedWarehouse = w;
                      });
                      fetchProducts();
                    },
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return Card(
                        child: ListTile(
                          title: Text(p.name),
                          subtitle:
                              Text('Кол-во: ${p.quantity}\nКод: ${p.code}'),
                          trailing: Text('${p.price} ₽'),
                          onLongPress: () async {
                            final changed = await showDialog<bool>(
                              context: context,
                              builder: (_) =>
                                  EditProductDialog(product: p),
                            );
                            if (changed == true) fetchProducts();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
