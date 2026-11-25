import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_store.dart';
import '../utils/format.dart';

Future<void> confirmDelete(BuildContext context, Expense expense) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Excluir despesa?'),
      content: Text('Deseja excluir "${expense.description}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
  if (ok == true) ExpenseStore.instance.remove(expense.id);
}

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final bool showDelete;

  const ExpenseTile({super.key, required this.expense, this.showDelete = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: expense.category.color,
        foregroundColor: Colors.white,
        child: Icon(expense.category.icon),
      ),
      title: Text(expense.description),
      subtitle: Text('${expense.category.label} • ${formatDate(expense.date)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatMoney(expense.amount),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (showDelete)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
              onPressed: () => confirmDelete(context, expense),
            ),
        ],
      ),
    );
  }
}
