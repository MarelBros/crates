import 'package:flutter/material.dart';
import '../models/product_create.dart';
import '../models/supplier.dart';
import '../models/warehouse.dart';
import '../services/api_service.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  Supplier? supplier;
  Warehouse? warehouse;

  List<Supplier> suppliers = [];
  List<Warehouse> warehouses = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    suppliers = await ApiService.getSuppliers();
    warehouses = await ApiService.getWarehouses();
    setState(() => loading = false);
  }

  bool _isValidCode128(String code) {
    final regex = RegExp(r'^[\x20-\x7E]+$'); 
    return regex.hasMatch(code);
  }

  void submit() async {
    final name = nameCtrl.text.trim();
    final price = double.tryParse(priceCtrl.text);
    final qty = int.tryParse(qtyCtrl.text);
    final code = codeCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Название не может быть пустым')),
      );
      return;
    }

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Цена должна быть положительным числом')),
      );
      return;
    }

    if (qty == null || qty < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Количество должно быть целым числом ≥ 1')),
      );
      return;
    }

    if (code.isNotEmpty && !_isValidCode128(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Код должен соответствовать стандарту Code 128')),
      );
      return;
    }

    if (supplier == null || warehouse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите склад и поставщика')),
      );
      return;
    }

    final dto = ProductCreate(
      name: name,
      price: price,
      code: code.isEmpty ? null : code,
      supplierID: supplier!.supplierID,
      warehouseID: warehouse!.warehouseID,
      initialQuantity: qty,
    );

    final ok = await ApiService.createProduct(dto);

    if (ok && mounted) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при создании товара')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый товар'),
      content: loading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Название'),
                  ),
                  TextField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(labelText: 'Цена'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: qtyCtrl,
                    decoration: const InputDecoration(labelText: 'Начальное количество'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
  controller: codeCtrl,
  decoration: InputDecoration(
    labelText: 'Код (необязательно)',
  ),
),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Warehouse>(
                    hint: const Text('Склад'),
                    value: warehouse,
                    items: warehouses
                        .map((w) => DropdownMenuItem(
                              value: w,
                              child: Text(w.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => warehouse = v),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Supplier>(
                    hint: const Text('Поставщик'),
                    value: supplier,
                    items: suppliers
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => supplier = v),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: submit,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
