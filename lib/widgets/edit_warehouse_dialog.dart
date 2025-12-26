import 'package:flutter/material.dart';
import '../models/warehouse.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class EditWarehouseDialog extends StatefulWidget {
  final Warehouse warehouse;
  const EditWarehouseDialog({required this.warehouse, super.key});

  @override
  State<EditWarehouseDialog> createState() => _EditWarehouseDialogState();
}

class _EditWarehouseDialogState extends State<EditWarehouseDialog> {
  late TextEditingController nameCtrl;
  bool loadingProducts = true;
  List<Product> productsInWarehouse = [];

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.warehouse.name);
    loadProducts();
  }

  Future<void> loadProducts() async {
    final allProducts = await ApiService.getProducts();
    productsInWarehouse = allProducts
        .where((p) => p.warehouse == widget.warehouse.name)
        .toList();
    setState(() => loadingProducts = false);
  }

  Future<void> save() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Название склада не может быть пустым')),
      );
      return;
    }

    final ok = await ApiService.updateWarehouse(widget.warehouse.warehouseID, name);
    if (ok && mounted) Navigator.pop(context, true);
  }

  Future<void> remove() async {
    if (loadingProducts) return; 
    if (productsInWarehouse.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Невозможно удалить склад: на складе есть продукты'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить склад?'),
        content: const Text('Эта операция необратима.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Удалить')),
        ],
      ),
    );

    if (confirmed != true) return;

    final ok = await ApiService.deleteWarehouse(widget.warehouse.warehouseID);
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактирование склада'),
      content: TextField(
        controller: nameCtrl,
        decoration: const InputDecoration(labelText: 'Название'),
      ),
      actions: [
        TextButton(
          onPressed: remove,
          child: const Text('Удалить', style: TextStyle(color: Colors.red)),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
        ElevatedButton(onPressed: save, child: const Text('Сохранить')),
      ],
    );
  }
}
