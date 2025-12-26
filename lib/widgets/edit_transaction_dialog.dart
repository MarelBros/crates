import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/product.dart';
import '../models/supplier.dart';
import '../services/api_service.dart';

class EditTransactionDialog extends StatefulWidget {
  final TransactionModel transaction;
  const EditTransactionDialog({super.key, required this.transaction});
  @override
  State<EditTransactionDialog> createState() => _EditTransactionDialogState();
}
class _EditTransactionDialogState extends State<EditTransactionDialog> {
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

   
    product = products.isNotEmpty
        ? products.firstWhere(
            (p) => p.name == widget.transaction.productName,
            orElse: () => products[0],
          )
        : null;

 
    supplier = suppliers.isNotEmpty
        ? suppliers.firstWhere(
            (s) => s.name == widget.transaction.supplierName,
            orElse: () => suppliers[0],
          )
        : null;

    type = widget.transaction.transactionType;
    qtyCtrl.text = widget.transaction.quantity.toString();

    setState(() => loading = false);
  }

  Future<void> submit() async {
    if (product == null || qtyCtrl.text.isEmpty) return;

    final qty = int.tryParse(qtyCtrl.text);
    if (qty == null || qty <= 0) {
      _showError('Количество должно быть положительным числом');
      return;
    }
    if (type == 'расход' && qty > product!.quantity) {
      _showError(
          'Недостаточно товара. Текущее количество: ${product!.quantity}');
      return;
    }

    final ok = await ApiService.updateTransaction(
      widget.transaction.transactionID,
      {
        'productID': product!.productID,
        'supplierID': supplier?.supplierID,
        'quantity': qty,
        'transactionType': type,
      },
    );

    if (ok && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> delete() async {
    final ok = await ApiService.deleteTransaction(widget.transaction.transactionID);

    if (ok && mounted) {
      Navigator.pop(context, true);
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ок'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать транзакцию'),
      content: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<Product>(
                    value: product,
                    items: products
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => product = v),
                    decoration: const InputDecoration(labelText: 'Товар'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Supplier>(
                    value: supplier,
                    items: suppliers
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => supplier = v),
                    decoration:
                        const InputDecoration(labelText: 'Поставщик (необязательно)'),
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
                    decoration: const InputDecoration(labelText: 'Тип транзакции'),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: delete,
          child: const Text('Удалить', style: TextStyle(color: Colors.red)),
        ),
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
