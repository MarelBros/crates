import 'package:crates/models/product.dart';
import 'package:crates/models/product_create.dart';
import 'package:crates/services/api_service.dart';
import 'package:flutter/material.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;
  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController codeCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product.name);
    priceCtrl = TextEditingController(text: widget.product.price.toString());
    codeCtrl = TextEditingController(text: widget.product.code);
  }

  bool _isValidCode128(String code) {
    final regex = RegExp(r'^[\x20-\x7E]+$'); 
    return regex.hasMatch(code);
  }

  void save() async {
    final name = nameCtrl.text.trim();
    final price = double.tryParse(priceCtrl.text);
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

    if (code.isNotEmpty && !_isValidCode128(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Код должен соответствовать стандарту Code 128')),
      );
      return;
    }

    final dto = ProductCreate(
      name: name,
      price: price,
      code: code.isEmpty ? null : code,
      supplierID: 1, 
      warehouseID: 1,
      initialQuantity: 1,
    );

    final ok = await ApiService.updateProduct(widget.product.productID, dto);
    if (ok && mounted) Navigator.pop(context, true);
  }

  void delete() async {
    final ok = await ApiService.deleteProduct(widget.product.productID);
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактирование товара'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
            controller: codeCtrl,
            decoration: const InputDecoration(labelText: 'Код (необязательно)'),
          ),
        ],
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
          onPressed: save,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
