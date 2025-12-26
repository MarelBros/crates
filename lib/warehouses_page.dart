import 'package:flutter/material.dart';
import '../models/warehouse.dart';
import '../services/api_service.dart';
import '../widgets/add_warehouse_dialog.dart';
import '../widgets/edit_warehouse_dialog.dart';

class WarehousesPage extends StatefulWidget {
  final Map<String, dynamic>? currentUser;
  const WarehousesPage({super.key, this.currentUser});

  @override
  State<WarehousesPage> createState() => _WarehousesPageState();
}

class _WarehousesPageState extends State<WarehousesPage> {
  List<Warehouse> warehouses = [];
  bool loading = true;

  bool get isAdmin => widget.currentUser != null && widget.currentUser!['tier'] == 1;

  Future<void> fetchWarehouses() async {
    setState(() => loading = true);
    warehouses = await ApiService.getWarehouses();
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => const AddWarehouseDialog(),
                );
                if (result == true) fetchWarehouses();
              },
            )
          : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: warehouses.length,
              itemBuilder: (_, i) {
                final w = warehouses[i];
                return Card(
                  child: ListTile(
                    title: Text(w.name),
                    onLongPress: isAdmin
                        ? () async {
                            final changed = await showDialog<bool>(
                              context: context,
                              builder: (_) => EditWarehouseDialog(warehouse: w),
                            );
                            if (changed == true) fetchWarehouses();
                          }
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
