import 'package:flutter/material.dart';
import '../services/expense_store.dart';
import '../utils/format.dart';
import '../widgets/expense_tile.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  Future<void> _editBudget(BuildContext context) async {
    final controller = TextEditingController(
      text: ExpenseStore.instance.budget.toStringAsFixed(2).replaceAll('.', ','),
    );
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Orçamento mensal'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            prefixText: 'R\$ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              ctx,
              double.tryParse(controller.text.replaceAll(',', '.')),
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null && value > 0) ExpenseStore.instance.setBudget(value);
  }

  @override
  Widget build(BuildContext context) {
    final store = ExpenseStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final total = store.monthTotal;
        final budget = store.budget;
        final double progress =
            budget > 0 ? (total / budget).clamp(0.0, 1.0).toDouble() : 0.0;
        final over = total > budget;
        final remaining = budget - total;
        final recent = store.expenses.take(5).toList();
        final now = DateTime.now();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Resumo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar orçamento',
                onPressed: () => _editBudget(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${monthName(now.month)} de ${now.year}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatMoney(total),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('gasto no mês'),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                        color: over ? Colors.red : Colors.green,
                      ),
                      const SizedBox(height: 8),
                      Text('Orçamento: ${formatMoney(budget)}'),
                      Text(
                        over
                            ? 'Você passou ${formatMoney(-remaining)} do orçamento'
                            : 'Restam ${formatMoney(remaining)}',
                        style: TextStyle(
                          color: over ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Últimas despesas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (recent.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Nenhuma despesa cadastrada.'),
                )
              else
                ...recent.map((e) => ExpenseTile(expense: e)),
            ],
          ),
        );
      },
    );
  }
}
