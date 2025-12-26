import 'package:flutter/material.dart';
import '../models/supplier.dart';
import '../services/api_service.dart';

class EditSupplierDialog extends StatefulWidget {
  final Supplier supplier;
  const EditSupplierDialog({required this.supplier, super.key});

  @override
  State<EditSupplierDialog> createState() => _EditSupplierDialogState();
}

class _EditSupplierDialogState extends State<EditSupplierDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController innCtrl;
  late TextEditingController phoneCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.supplier.name);
    innCtrl = TextEditingController(text: widget.supplier.inn);
    phoneCtrl = TextEditingController(text: widget.supplier.phone ?? '');
  }

  String? _formatPhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11 || !digits.startsWith('7')) return null;

    final code = digits.substring(1, 4);
    final first = digits.substring(4, 7);
    final second = digits.substring(7, 9);
    final third = digits.substring(9, 11);

    return '+7($code)$first-$second-$third';
  }

  Future<void> submit() async {
    final name = nameCtrl.text.trim();
    final inn = innCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Название не может быть пустым')),
      );
      return;
    }

    if (!RegExp(r'^\d{12}$').hasMatch(inn)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ИНН должен содержать ровно 12 цифр')),
      );
      return;
    }

    String? formattedPhone;
    if (phone.isNotEmpty) {
      formattedPhone = _formatPhone(phone);
      if (formattedPhone == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный формат телефона')),
        );
        return;
      }
    }

    final ok = await ApiService.updateSupplier(widget.supplier.supplierID, {
      'name': name,
      'inn': inn,
      'phone': formattedPhone,
    });

    if (ok && mounted) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  Future<void> deleteSupplier() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить поставщика?'),
        content: const Text('Эта операция необратима.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить')),
        ],
      ),
    );

    if (confirmed != true) return;

    final ok = await ApiService.deleteSupplier(widget.supplier.supplierID);
    if (ok && mounted) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать поставщика'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: innCtrl,
            decoration: const InputDecoration(labelText: 'ИНН'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: phoneCtrl,
            decoration: const InputDecoration(labelText: 'Телефон'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: deleteSupplier,
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
