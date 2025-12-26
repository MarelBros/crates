import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddSupplierDialog extends StatefulWidget {
  const AddSupplierDialog({super.key});

  @override
  State<AddSupplierDialog> createState() => _AddSupplierDialogState();
}

class _AddSupplierDialogState extends State<AddSupplierDialog> {
  final nameCtrl = TextEditingController();
  final innCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  String? _formatPhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11 || !digits.startsWith('7')) return null;

    final code = digits.substring(1, 4);
    final first = digits.substring(4, 7);
    final second = digits.substring(7, 9);
    final third = digits.substring(9, 11);

    return '+7($code)$first-$second-$third';
  }

  void submit() async {
    final name = nameCtrl.text.trim();
    final inn = innCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    // Валидация
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

    final ok = await ApiService.createSupplier(
      name: name,
      inn: inn,
      phone: formattedPhone,
    );

    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый поставщик'),
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
