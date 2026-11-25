import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_store.dart';
import '../widgets/expense_tile.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  ExpenseCategory? _filter;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ExpenseStore.instance,
      builder: (context, _) {
        final all = ExpenseStore.instance.expenses;
        final list = _filter == null
            ? all
            : all.where((e) => e.category == _filter).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Despesas')),
          body: Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('Todas'),
                        selected: _filter == null,
                        onSelected: (_) => setState(() => _filter = null),
                      ),
                    ),
                    ...ExpenseCategory.values.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c.label),
                          selected: _filter == c,
                          onSelected: (_) => setState(() => _filter = c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('Nenhuma despesa encontrada.'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 88),
                        itemCount: list.length,
                        itemBuilder: (context, index) =>
                            ExpenseTile(expense: list[index], showDelete: true),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
