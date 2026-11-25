import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_store.dart';
import '../utils/format.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ExpenseStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final totals = store.totalsByCategory;
        final total = store.monthTotal;
        final now = DateTime.now();

        return Scaffold(
          appBar: AppBar(title: const Text('Categorias')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              Text(
                'Gastos de ${monthName(now.month)} por categoria',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ...ExpenseCategory.values.map((c) {
                final value = totals[c] ?? 0.0;
                final double pct = total > 0 ? value / total : 0.0;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: c.color,
                              foregroundColor: Colors.white,
                              child: Icon(c.icon),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                c.label,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              formatMoney(value),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                          color: c.color,
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('${(pct * 100).toStringAsFixed(0)}% do total'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
