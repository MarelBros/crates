import 'package:flutter/material.dart';
import '../models/supplier.dart';
import '../services/api_service.dart';
import '../widgets/edit_supplier_dialog.dart';
import '../widgets/add_supplier_dialog.dart';

class SuppliersPage extends StatefulWidget {
  final Map<String, dynamic>? currentUser;
  const SuppliersPage({super.key, this.currentUser});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  List<Supplier> suppliers = [];
  bool loading = true;

  bool get isAdmin => widget.currentUser != null && widget.currentUser!['tier'] == 1;

  Future<void> fetchSuppliers() async {
    setState(() => loading = true);
    suppliers = await ApiService.getSuppliers();
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
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
                  builder: (_) => const AddSupplierDialog(),
                );
                if (result == true) fetchSuppliers();
              },
            )
          : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (_, i) {
                final s = suppliers[i];
                return Card(
                  child: ListTile(
                    title: Text(s.name),
                    subtitle: Text('ИНН: ${s.inn}\n${s.phone ?? ''}'),
                    onLongPress: isAdmin
                        ? () async {
                            final changed = await showDialog<bool>(
                              context: context,
                              builder: (_) => EditSupplierDialog(supplier: s),
                            );
                            if (changed == true) fetchSuppliers();
                          }
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
