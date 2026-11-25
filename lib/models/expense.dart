import 'package:flutter/material.dart';

enum ExpenseCategory {
  alimentacao('Alimentação', Icons.restaurant, Colors.orange),
  transporte('Transporte', Icons.directions_bus, Colors.blue),
  lazer('Lazer', Icons.sports_esports, Colors.purple),
  saude('Saúde', Icons.favorite, Colors.red),
  educacao('Educação', Icons.school, Colors.teal),
  moradia('Moradia', Icons.home, Colors.brown),
  outros('Outros', Icons.category, Colors.grey);

  final String label;
  final IconData icon;
  final Color color;

  const ExpenseCategory(this.label, this.icon, this.color);
}

class Expense {
  final String id;
  final String description;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  const Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });
}
