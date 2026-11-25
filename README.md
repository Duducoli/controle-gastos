# Controle de Gastos

Aplicativo de controle de gastos pessoais feito em **Flutter** (Dart) como trabalho da faculdade.

## Funcionalidades

- Cadastro de despesas (descrição, valor, categoria e data) com validação
- Lista de despesas com filtro por categoria e exclusão com confirmação
- Resumo do mês: total gasto, orçamento editável, saldo e barra de progresso
- Gastos por categoria, com valor e percentual
- Tela de boas-vindas e tela Sobre (6 telas no total)

Os dados ficam apenas na memória: ao fechar o app, eles são apagados e as despesas de exemplo voltam.

## Telas

| Tela | O que faz |
|---|---|
| Boas-vindas | Entrada do app |
| Resumo | Total do mês, orçamento e últimas despesas |
| Despesas | Lista completa, filtro e exclusão |
| Nova despesa | Formulário de cadastro |
| Categorias | Gasto por categoria |
| Sobre | Informações do app |

## Como rodar

Pré-requisito: [Flutter](https://docs.flutter.dev/get-started/install) instalado e o Chrome.

```bash
git clone URL_DO_REPOSITORIO
cd NOME_DA_PASTA
flutter create --platforms=web,android --project-name controle_gastos .
flutter pub get
flutter run -d chrome
```

O comando `flutter create .` gera as pastas de plataforma (`web`, `android`) que não ficam no repositório. Ele não apaga o código de `lib/`.

## Estrutura

```
lib/
  main.dart
  models/      classes de dados (Expense, ExpenseCategory)
  utils/       formatação de valores e datas
  services/    armazenamento das despesas na memória (ExpenseStore)
  widgets/     componentes reutilizáveis (ExpenseTile)
  screens/     as telas do app
```

## Tecnologias

Flutter, Dart e Material Design 3. Sem pacotes externos e sem API.

## Autor

Eduardo Cordeiro de Oliveira
