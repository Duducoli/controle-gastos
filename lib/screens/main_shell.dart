import 'package:flutter/material.dart';
import 'summary_screen.dart';
import 'expenses_screen.dart';
import 'categories_screen.dart';
import 'about_screen.dart';
import 'add_expense_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    SummaryScreen(),
    ExpensesScreen(),
    CategoriesScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: _index < 3
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Nova despesa'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Resumo'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Despesas'),
          NavigationDestination(icon: Icon(Icons.pie_chart), label: 'Categorias'),
          NavigationDestination(icon: Icon(Icons.info_outline), label: 'Sobre'),
        ],
      ),
    );
  }
}
