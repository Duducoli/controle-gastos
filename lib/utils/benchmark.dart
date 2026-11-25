import '../models/expense.dart';
import '../services/expense_store.dart';

class BenchmarkResult {
  final int count; // quantidade de despesas
  final int rounds; // quantas atualizações foram simuladas
  final double naiveMs; // ANTES: recalcula tudo a cada leitura
  final double optimizedMs; // DEPOIS: usa o cache
  final double check; // usado só para o compilador não descartar o cálculo

  const BenchmarkResult({
    required this.count,
    required this.rounds,
    required this.naiveMs,
    required this.optimizedMs,
    required this.check,
  });

  double get speedup => optimizedMs > 0 ? naiveMs / optimizedMs : 0;
}

// ---- Versão "ANTES": o que o app fazia na primeira versão ----
// Cada leitura ordenava a lista inteira de novo.
List<Expense> _naiveExpenses(List<Expense> data) {
  final list = List<Expense>.from(data);
  list.sort((a, b) => b.date.compareTo(a.date));
  return list;
}

List<Expense> _naiveMonth(List<Expense> data) {
  final now = DateTime.now();
  return _naiveExpenses(data)
      .where((e) => e.date.year == now.year && e.date.month == now.month)
      .toList();
}

double _naiveTotal(List<Expense> data) =>
    _naiveMonth(data).fold<double>(0, (sum, e) => sum + e.amount);

Map<ExpenseCategory, double> _naiveByCategory(List<Expense> data) {
  final map = <ExpenseCategory, double>{};
  for (final e in _naiveMonth(data)) {
    map[e.category] = (map[e.category] ?? 0) + e.amount;
  }
  return map;
}

// Simula [rounds] atualizações. Em cada uma entra uma despesa nova e as telas
// Resumo, Despesas e Categorias leem os dados (5 leituras, como no app).
BenchmarkResult runBenchmark(int count, {int rounds = 30}) {
  final base = ExpenseStore.generate(count, prefix: 'b');
  final extra = ExpenseStore.generate(rounds, prefix: 'x');
  double check = 0;

  // ANTES
  final naiveData = List<Expense>.from(base);
  final sw1 = Stopwatch()..start();
  for (var i = 0; i < rounds; i++) {
    naiveData.add(extra[i]);
    check += _naiveTotal(naiveData); // Resumo: total do mês
    check += _naiveExpenses(naiveData).take(5).length; // Resumo: últimas
    check += _naiveByCategory(naiveData).length; // Categorias: por categoria
    check += _naiveTotal(naiveData); // Categorias: total
    check += _naiveExpenses(naiveData).length; // Despesas: lista
  }
  sw1.stop();

  // DEPOIS
  final store = ExpenseStore.withData(base);
  final sw2 = Stopwatch()..start();
  for (var i = 0; i < rounds; i++) {
    store.add(extra[i]);
    check += store.monthTotal;
    check += store.expenses.take(5).length;
    check += store.totalsByCategory.length;
    check += store.monthTotal;
    check += store.expenses.length;
  }
  sw2.stop();
  store.dispose();

  return BenchmarkResult(
    count: count,
    rounds: rounds,
    naiveMs: sw1.elapsedMicroseconds / 1000,
    optimizedMs: sw2.elapsedMicroseconds / 1000,
    check: check,
  );
}
