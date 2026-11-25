import 'package:flutter/material.dart';
import '../services/expense_store.dart';
import '../utils/benchmark.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  BenchmarkResult? _result;
  bool _running = false;

  Future<void> _run(int count) async {
    setState(() => _running = true);
    // Dá tempo de o indicador de progresso aparecer antes do cálculo.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final result = runBenchmark(count);
    if (!mounted) return;
    setState(() {
      _result = result;
      _running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = ExpenseStore.instance;
    final result = _result;

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Icon(Icons.account_balance_wallet, size: 80, color: Colors.green),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Controle de Gastos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          const Center(child: Text('Versão 1.0')),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('Descrição'),
            subtitle: Text(
              'Aplicativo para registrar despesas, acompanhar o orçamento do mês e ver os gastos por categoria.',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Armazenamento'),
            subtitle: Text('Os dados ficam na memória e são apagados ao fechar o app.'),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Tecnologias'),
            subtitle: Text('Flutter e Dart'),
          ),
          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Desenvolvido por'),
            subtitle: Text('Eduardo Cordeiro de Oliveira'),
          ),
          const Divider(height: 32),
          const Text(
            'Teste de desempenho',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ferramentas usadas para medir e demonstrar o desempenho. '
            'Os números dependem do computador e do navegador.',
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: store,
            builder: (context, _) => Text(
              'Despesas carregadas: ${store.expenses.length} '
              '(${store.stressCount} de teste)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: () => store.loadStressData(5000),
                child: const Text('Carregar 5.000 despesas'),
              ),
              OutlinedButton(
                onPressed: store.clearStressData,
                child: const Text('Remover despesas de teste'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Medir antes x depois:'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: _running ? null : () => _run(1000),
                child: const Text('1.000 despesas'),
              ),
              OutlinedButton(
                onPressed: _running ? null : () => _run(5000),
                child: const Text('5.000 despesas'),
              ),
              OutlinedButton(
                onPressed: _running ? null : () => _run(20000),
                child: const Text('20.000 despesas'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_running) const Center(child: CircularProgressIndicator()),
          if (result != null && !_running)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${result.count} despesas • ${result.rounds} atualizações',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Antes (recalcula tudo): ${result.naiveMs.toStringAsFixed(1)} ms'),
                    Text('Depois (com cache): ${result.optimizedMs.toStringAsFixed(1)} ms'),
                    const SizedBox(height: 4),
                    Text(
                      result.optimizedMs > 0
                          ? 'Ganho: ${result.speedup.toStringAsFixed(1)}x mais rápido'
                          : 'Ganho: depois foi rápido demais para medir',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
