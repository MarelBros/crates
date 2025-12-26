import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';
import '../widgets/edit_transaction_dialog.dart';
import '../widgets/add_transaction_dialog.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<TransactionModel> list = [];
  bool loading = true;

  Future<void> fetch() async {
    setState(() => loading = true);
    list = await ApiService.getTransactions();
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Color typeColor(String type) => type == 'приход' ? Colors.green : Colors.red;

  IconData typeIcon(String type) =>
      type == 'приход' ? Icons.arrow_downward : Icons.arrow_upward;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (_) => const AddTransactionDialog(),
          );
          if (ok == true) fetch();
        },
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final t = list[i];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      typeIcon(t.transactionType),
                      color: typeColor(t.transactionType),
                      size: 32,
                    ),
                    title: Text(
                      t.productName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      '${t.transactionDate.toLocal()}\n${t.supplierName ?? ''}',
                    ),
                    trailing: Text(
                      '${t.quantity}',
                      style: TextStyle(
                        color: typeColor(t.transactionType),
                        fontWeight: FontWeight.bold,
                        fontSize: 20, 
                      ),
                    ),
                    onLongPress: () async {
                      final changed = await showDialog<bool>(
                        context: context,
                        builder: (_) => EditTransactionDialog(transaction: t),
                      );
                      if (changed == true) fetch();
                    },
                  ),
                );
              },
            ),
    );
  }
}
