# Medição de desempenho (antes x depois)

Preencha as tabelas com os números que aparecerem no SEU computador. Não use números de outra pessoa.

## 1. Rode em modo profile

O modo debug é bem mais lento e não serve para medir. Pare o app e rode:

```
flutter run -d chrome --profile
```

## 2. Teste de cálculo (dentro do app)

1. Abra a tela **Sobre** e role até **Teste de desempenho**.
2. Clique em **1.000**, **5.000** e **20.000 despesas**. Cada clique mostra o tempo do "antes" e do "depois".
3. Repita cada botão 3 vezes e anote o valor mais comum (o primeiro costuma ser mais lento).
4. Tire um print de cada resultado.

| Despesas | Antes (ms) | Depois (ms) | Ganho |
|---|---|---|---|
| 1.000 | | | |
| 5.000 | | | |
| 20.000 | | | |

Observação: o "antes" é a lógica da primeira versão (ordenar a lista a cada leitura) e o "depois" é a versão com cache da classe `ExpenseStore`.

## 3. Fluidez da lista (FPS)

1. Na tela **Sobre**, clique em **Carregar 5.000 despesas**.
2. Vá para **Despesas** e role a lista rápido para cima e para baixo.
3. No Chrome, aperte `F12`, abra o menu `⋮` → **More tools** → **Rendering** e marque **Frame Rendering Stats**. O medidor de FPS aparece no canto da tela.
4. Anote o FPS enquanto rola e tire um print.

| Situação | FPS ao rolar |
|---|---|
| ListView.builder, 5.000 itens (versão atual) | |
| (opcional) ListView com todos os itens criados de uma vez | |

Experimento opcional para a segunda linha: em `lib/screens/expenses_screen.dart`, troque temporariamente o `ListView.builder` por
```dart
ListView(
  padding: const EdgeInsets.only(bottom: 88),
  children: list.map((e) => ExpenseTile(expense: e, showDelete: true)).toList(),
)
```
meça, e depois **volte ao código original**.

## 4. Memória

1. Com `F12` aberto, vá na aba **Performance monitor** (menu `⋮` → **More tools**) e veja **JS heap size**.
2. Anote o valor com o app recém-aberto e depois de carregar as 5.000 despesas de teste.
3. Clique em **Remover despesas de teste** e veja se o valor volta a cair (pode precisar do botão de coletar lixo na aba **Memory**).

| Momento | JS heap (MB) |
|---|---|
| App recém-aberto | |
| Com 5.000 despesas de teste | |
| Depois de remover | |

## Avisos honestos

- Os números mudam de computador para computador e entre execuções. Diga isso na apresentação.
- No navegador, o app roda em JavaScript e não usa o profiler de memória do Flutter DevTools do mesmo jeito que em Android. Por isso a medição aqui usa o Chrome DevTools.
- Se tiver um celular Android ou emulador, dá para repetir as medidas com o Flutter DevTools (aba Performance e Memory).
