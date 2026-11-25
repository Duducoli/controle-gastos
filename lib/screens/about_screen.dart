import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Center(
            child: Icon(Icons.account_balance_wallet, size: 80, color: Colors.green),
          ),
          SizedBox(height: 12),
          Center(
            child: Text(
              'Controle de Gastos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 4),
          Center(child: Text('Versão 1.0')),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('Descrição'),
            subtitle: Text(
              'Aplicativo para registrar despesas, acompanhar o orçamento do mês e ver os gastos por categoria.',
            ),
          ),
          ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Armazenamento'),
            subtitle: Text('Os dados ficam na memória e são apagados ao fechar o app.'),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text('Tecnologias'),
            subtitle: Text('Flutter e Dart'),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Desenvolvido por'),
            subtitle: Text('Eduardo Cordeiro de Oliveira'),
          ),
        ],
      ),
    );
  }
}
