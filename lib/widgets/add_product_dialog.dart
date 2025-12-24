import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product_create.dart';
import '../models/supplier.dart';
import '../models/warehouse.dart';
import '../services/api_service.dart';

class AddProductDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  const AddProductDialog({required this.onSuccess});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  Supplier? supplier;
  Warehouse? warehouse;

  List<Supplier> suppliers = [];
  List<Warehouse> warehouses = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    suppliers = await ApiService.getSuppliers();
    warehouses = await ApiService.getWarehouses();
    setState(() {});
  }

  String generateBarcode128() {
    final rnd = Random();
    return List.generate(12, (_) => rnd.nextInt(10)).join();
  }

  void submit() async {
    if (supplier == null || warehouse == null) return;

    final dto = ProductCreate(
      name: nameCtrl.text,
      quantity: int.parse(qtyCtrl.text),
      productCode: codeCtrl.text,
      supplierID: supplier!.supplierID,
      warehouseID: warehouse!.warehouseID,
    );

    final ok = await ApiService.createProduct(dto);
    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Новый продукт'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Название')),
            TextField(controller: qtyCtrl, decoration: InputDecoration(labelText: 'Количество'), keyboardType: TextInputType.number),

            DropdownButtonFormField<Supplier>(
              hint: Text('Поставщик'),
              items: suppliers
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => supplier = v,
            ),

            DropdownButtonFormField<Warehouse>(
              hint: Text('Склад'),
              items: warehouses
                  .map((w) => DropdownMenuItem(value: w, child: Text(w.name)))
                  .toList(),
              onChanged: (v) => warehouse = v,
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codeCtrl,
                    decoration: InputDecoration(labelText: 'Штрихкод'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () => setState(() {
                    codeCtrl.text = generateBarcode128();
                  }),
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Отмена')),
        ElevatedButton(onPressed: submit, child: Text('Сохранить')),
      ],
    );
  }
}