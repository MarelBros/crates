import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../models/supplier.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  Product? product;
  Supplier? supplier;
  String type = 'приход';

  final qtyCtrl = TextEditingController();

  List<Product> products = [];
  List<Supplier> suppliers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    products = await ApiService.getProducts();
    suppliers = await ApiService.getSuppliers();
    setState(() => loading = false);
  }

  Future<void> submit() async {
    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выберите товар')));
      return;
    }

    int? qty = int.tryParse(qtyCtrl.text);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите корректное количество')));
      return;
    }

    if (type == 'расход' && qty > product!.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Невозможно списать $qty, доступно только ${product!.quantity}')));
      return;
    }

    final ok = await ApiService.createTransaction({
      'productID': product!.productID,
      'supplierID': supplier?.supplierID,
      'quantity': qty,
      'transactionType': type,
    });

    if (ok && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая транзакция'),
      content: loading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<Product>(
                    hint: const Text('Товар'),
                    value: product,
                    items: products
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text('${p.name} (доступно: ${p.quantity})'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => product = v),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<Supplier>(
                    hint: const Text('Поставщик (необязательно)'),
                    value: supplier,
                    items: suppliers
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => supplier = v),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Количество'),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: type,
                    items: const [
                      DropdownMenuItem(value: 'приход', child: Text('Приход')),
                      DropdownMenuItem(value: 'расход', child: Text('Расход')),
                    ],
                    onChanged: (v) => setState(() => type = v!),
                    decoration:
                        const InputDecoration(labelText: 'Тип транзакции'),
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
