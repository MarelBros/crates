import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddWarehouseDialog extends StatefulWidget {
  const AddWarehouseDialog({super.key});

  @override
  State<AddWarehouseDialog> createState() => _AddWarehouseDialogState();
}

class _AddWarehouseDialogState extends State<AddWarehouseDialog> {
  final nameCtrl = TextEditingController();

  Future<void> submit() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Название склада не может быть пустым')),
      );
      return;
    }

    final ok = await ApiService.createWarehouse(name);
    if (ok && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый склад'),
      content: TextField(
        controller: nameCtrl,
        decoration: const InputDecoration(labelText: 'Название'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
        ElevatedButton(onPressed: submit, child: const Text('Сохранить')),
      ],
    );
  }
}

