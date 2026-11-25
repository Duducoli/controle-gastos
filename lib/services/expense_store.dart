import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/expense.dart';

// Guarda as despesas na memória e avisa as telas quando algo muda.
//
// Otimização: a lista ordenada, as despesas do mês, o total e os totais por
// categoria são calculados UMA vez e reaproveitados (cache) até os dados
// mudarem. Antes, cada leitura ordenava a lista inteira de novo.
class ExpenseStore extends ChangeNotifier {
  ExpenseStore._(List<Expense> initial) {
    _expenses.addAll(initial);
  }

  // Loja com dados próprios (usada no teste de desempenho).
  ExpenseStore.withData(List<Expense> initial) : this._(initial);

  static final ExpenseStore instance = ExpenseStore._(sampleData());

  final List<Expense> _expenses = [];
  double _budget = 1000;

  // ---- Cache ----
  List<Expense>? _sortedCache;
  List<Expense>? _monthCache;
  int? _monthKey;
  double? _totalCache;
  Map<ExpenseCategory, double>? _categoryCache;

  void _invalidate() {
    _sortedCache = null;
    _monthCache = null;
    _totalCache = null;
    _categoryCache = null;
  }

  double get budget => _budget;

  // Todas as despesas, da mais recente para a mais antiga.
  List<Expense> get expenses {
    return _sortedCache ??= List<Expense>.unmodifiable(
      List<Expense>.of(_expenses)..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  // Somente as despesas do mês atual.
  List<Expense> get currentMonth {
    final now = DateTime.now();
    final key = now.year * 100 + now.month;
    // Recalcula se os dados mudaram ou se virou o mês.
    if (_monthCache == null || _monthKey != key) {
      _monthKey = key;
      _monthCache = List<Expense>.unmodifiable(
        expenses.where((e) => e.date.year == now.year && e.date.month == now.month),
      );
      _totalCache = null;
      _categoryCache = null;
    }
    return _monthCache!;
  }

  double get monthTotal {
    final month = currentMonth; // garante que o cache do mês está válido
    return _totalCache ??= month.fold<double>(0, (sum, e) => sum + e.amount);
  }

  Map<ExpenseCategory, double> get totalsByCategory {
    final month = currentMonth;
    final cached = _categoryCache;
    if (cached != null) return cached;

    final map = <ExpenseCategory, double>{};
    for (final e in month) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return _categoryCache = Map<ExpenseCategory, double>.unmodifiable(map);
  }

  void add(Expense expense) {
    _expenses.add(expense);
    _invalidate();
    notifyListeners();
  }

  void remove(String id) {
    _expenses.removeWhere((e) => e.id == id);
    _invalidate();
    notifyListeners();
  }

  void setBudget(double value) {
    _budget = value;
    notifyListeners();
  }

  // ---- Dados de teste (para a apresentação) ----
  static const _stressPrefix = 'teste_';

  int get stressCount =>
      _expenses.where((e) => e.id.startsWith(_stressPrefix)).length;

  // Adiciona [n] despesas de teste de uma vez (uma única notificação).
  void loadStressData(int n) {
    final prefix = '$_stressPrefix${DateTime.now().microsecondsSinceEpoch}_';
    _expenses.addAll(generate(n, prefix: prefix));
    _invalidate();
    notifyListeners();
  }

  void clearStressData() {
    _expenses.removeWhere((e) => e.id.startsWith(_stressPrefix));
    _invalidate();
    notifyListeners();
  }

  // Despesas de exemplo que o app tem ao iniciar.
  static List<Expense> sampleData() {
    final now = DateTime.now();
    return [
      Expense(id: '1', description: 'Almoço', amount: 32.5, category: ExpenseCategory.alimentacao, date: now),
      Expense(id: '2', description: 'Ônibus', amount: 4.5, category: ExpenseCategory.transporte, date: now.subtract(const Duration(days: 1))),
      Expense(id: '3', description: 'Cinema', amount: 28.0, category: ExpenseCategory.lazer, date: now.subtract(const Duration(days: 2))),
      Expense(id: '4', description: 'Livro de estudo', amount: 59.9, category: ExpenseCategory.educacao, date: now.subtract(const Duration(days: 3))),
      Expense(id: '5', description: 'Farmácia', amount: 18.75, category: ExpenseCategory.saude, date: now.subtract(const Duration(days: 4))),
    ];
  }

  // Gera [n] despesas aleatórias (sempre as mesmas, pois a semente é fixa).
  static List<Expense> generate(int n, {String prefix = 'g'}) {
    final random = Random(42);
    final now = DateTime.now();
    final categories = ExpenseCategory.values;
    return List<Expense>.generate(
      n,
      (i) => Expense(
        id: '$prefix$i',
        description: 'Despesa de teste ${i + 1}',
        amount: 1 + random.nextInt(50000) / 100,
        category: categories[random.nextInt(categories.length)],
        date: now.subtract(Duration(days: random.nextInt(60))),
      ),
    );
  }
}
