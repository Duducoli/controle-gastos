import 'package:flutter/foundation.dart';
import '../models/expense.dart';

// Guarda as despesas na memória e avisa as telas quando algo muda.
class ExpenseStore extends ChangeNotifier {
  ExpenseStore._() {
    final now = DateTime.now();
    _expenses.addAll([
      Expense(id: '1', description: 'Almoço', amount: 32.5, category: ExpenseCategory.alimentacao, date: now),
      Expense(id: '2', description: 'Ônibus', amount: 4.5, category: ExpenseCategory.transporte, date: now.subtract(const Duration(days: 1))),
      Expense(id: '3', description: 'Cinema', amount: 28.0, category: ExpenseCategory.lazer, date: now.subtract(const Duration(days: 2))),
      Expense(id: '4', description: 'Livro de estudo', amount: 59.9, category: ExpenseCategory.educacao, date: now.subtract(const Duration(days: 3))),
      Expense(id: '5', description: 'Farmácia', amount: 18.75, category: ExpenseCategory.saude, date: now.subtract(const Duration(days: 4))),
    ]);
  }

  static final ExpenseStore instance = ExpenseStore._();

  final List<Expense> _expenses = [];
  double _budget = 1000;

  double get budget => _budget;

  // Todas as despesas, da mais recente para a mais antiga.
  List<Expense> get expenses {
    final list = List<Expense>.from(_expenses);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  // Somente as despesas do mês atual.
  List<Expense> get currentMonth {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .toList();
  }

  double get monthTotal =>
      currentMonth.fold<double>(0, (sum, e) => sum + e.amount);

  Map<ExpenseCategory, double> get totalsByCategory {
    final map = <ExpenseCategory, double>{};
    for (final e in currentMonth) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  void add(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void remove(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setBudget(double value) {
    _budget = value;
    notifyListeners();
  }
}
