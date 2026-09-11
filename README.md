# Manipula-o-de-array-em-assembly
Rotinas de baixo nível para abertura dinâmica de vãos e alinhamento de arrays, desenvolvidas em Assembly x86-64 para optmização de algoritmos e integradas a código C.

## 🎯 Problema que o projeto resolve

**Binary Search** e **Quick Sort** estão entre os algoritmos clássicos mais eficientes para busca e ordenação em arrays.
Apesar de serem extremamente eficientes,o algortimo quebra quando um array sofre inserções, remoções ou reorganizações e passa a possuir vãos internos na memória:

**A | B | -1 | C | D | -1 | E | F**

##### Nota: -1 indica que o elemento é um burraco na memória

⚠️ Nesse estado, os elementos válidos deixam de formar uma **sequência linear e compacta de memória**.

A **Binary Search** depende do acesso direto aos elementos por índice e de uma sequência ordenada e contígua para reduzir o espaço de busca. Se a estrutura deixa de representar essa sequência, sua lógica de indexação deixa de ser válida.

O **Quick Sort** também trabalha sobre regiões contíguas do array, realizando particionamentos e movimentações entre elementos. Com espaços internos e elementos inválidos misturados aos dados, a estrutura precisa ser reorganizada antes da aplicação eficiente da rotina.


### 🔨 A solução

Este projeto implementa duas rotinas em **Assembly x86-64** para resolver esse problema:

🔹 **AbrirVao**
Desloca fisicamente blocos de memória para criar um espaço em um índice específico.

🔹 **AlinharArray**
Localiza os vãos e desloca os elementos válidos para trás, restaurando a linearidade do array:

```text
A | B | -1 | C | D | -1 | E | F
                ↓
A | B | C | D | E | F | -1 | -1

```


### 🧠 O diferencial

As rotinas não conhecem o tipo dos elementos. O Assembly recebe apenas:

```text
📍 Endereço inicial
📍 Endereço final
📍 Posição da operação
📏 Tamanho do elemento
```
Nessa versão final, o algoritmo consegue:<br>

✅ Alinhar o array em uma única chamada<br>
✅ Abrir vãos em índices específicos<br>
✅ Manipular tipos primitivos e ponteiros<br>
✅ Trabalhar com estruturas complexas do C

```text

typedef struct {

    int64_t id;
    int32_t idade;
    int32_t ddd;
    int64_t telefone;
    char nome[32];
    double salario;
} Pessoa;

```




Tudo através de **ponteiros genéricos (`void *`) e movimentação direta de blocos na memória**.


### ⚙️ Resultado

O projeto mantém os elementos válidos em uma **região linear e compacta da memória**, restaurando a estrutura necessária para que algoritmos de busca e ordenação baseados em arrays possam operar sobre os dados sem precisar lidar com vãos internos.

### 🖥️ Saida
Demostração de uso no terminal:

```text
thermius@arch: ./a.out 
Antes da chamada assembly para ABRIR UM VÃO:
1
11
21
31
41
51
61
71
81
91
101
111
121
131
141
151
161
171
181
191
Vão aberto no incide 3:
1
11
21
-1
31
41
51
61
71
81
91
101
111
121
131
141
151
161
171
181
Vão aberto no incide 8:
1
11
21
-1
31
41
51
61
-1
71
81
91
101
111
121
131
141
151
161
171
Vão aberto no incide penultimo indice:
1
11
21
-1
31
41
51
61
-1
71
81
91
101
111
121
131
141
151
-1
161

Chamando assembly para alinhar array
Array alinhado:
1
11
21
31
41
51
61
71
81
91
101
111
121
131
141
151
161
-1
-1
-1

*********************Demostração de estrutura complexa***********************
Tamanho da struct: 64 bytes

ANTES:
[00] ID: 1 | Nome: Ana          | Idade: 25 | DDD: 71 | Telefone: 999111111 | Salario: 2500.00
[01] ID: 2 | Nome: Bruno        | Idade: 31 | DDD: 71 | Telefone: 999222222 | Salario: 3200.00
[02] ID: 3 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[03] ID: 4 | Nome: Diana        | Idade: 28 | DDD: 71 | Telefone: 999444444 | Salario: 2800.00
[04] ID: 5 | Nome: Eduardo      | Idade: 35 | DDD: 71 | Telefone: 999555555 | Salario: 3900.00
[05] ID: 6 | Nome: Fernanda     | Idade: 22 | DDD: 71 | Telefone: 999666666 | Salario: 2100.00
[06] ID: 7 | Nome: Gabriel      | Idade: 39 | DDD: 71 | Telefone: 999777777 | Salario: 5000.00
[07] ID: 8 | Nome: Helena       | Idade: 27 | DDD: 71 | Telefone: 999888888 | Salario: 3100.00
[08] ID: 9 | Nome: Igor         | Idade: 45 | DDD: 71 | Telefone: 999999999 | Salario: 6200.00
[09] ID: 10 | Nome: Julia        | Idade: 33 | DDD: 71 | Telefone: 998111111 | Salario: 3700.00
[10] ID: 11 | Nome: Kleber       | Idade: 29 | DDD: 71 | Telefone: 998222222 | Salario: 2900.00
[11] ID: 12 | Nome: Larissa      | Idade: 41 | DDD: 71 | Telefone: 998333333 | Salario: 4300.00
[12] ID: 13 | Nome: Marcos       | Idade: 26 | DDD: 71 | Telefone: 998444444 | Salario: 2700.00
[13] ID: 14 | Nome: Natalia      | Idade: 38 | DDD: 71 | Telefone: 998555555 | Salario: 5100.00
[14] ID: 15 | Nome: Otavio       | Idade: 24 | DDD: 71 | Telefone: 998666666 | Salario: 2300.00
[15] ID: 16 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[16] ID: 17 | Nome: Rafael       | Idade: 30 | DDD: 71 | Telefone: 998888888 | Salario: 3500.00
[17] ID: 18 | Nome: Sabrina      | Idade: 44 | DDD: 71 | Telefone: 998999999 | Salario: 5800.00
[18] ID: 19 | Nome: Thiago       | Idade: 32 | DDD: 71 | Telefone: 997111111 | Salario: 3900.00
[19] ID: 20 | Nome: Vanessa      | Idade: 37 | DDD: 71 | Telefone: 997222222 | Salario: 4700.00

DEPOIS DO VAO NO INDICE 3:
[00] ID: 1 | Nome: Ana          | Idade: 25 | DDD: 71 | Telefone: 999111111 | Salario: 2500.00
[01] ID: 2 | Nome: Bruno        | Idade: 31 | DDD: 71 | Telefone: 999222222 | Salario: 3200.00
[02] ID: 3 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[03] ID: -1 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[04] ID: 4 | Nome: Diana        | Idade: 28 | DDD: 71 | Telefone: 999444444 | Salario: 2800.00
[05] ID: 5 | Nome: Eduardo      | Idade: 35 | DDD: 71 | Telefone: 999555555 | Salario: 3900.00
[06] ID: 6 | Nome: Fernanda     | Idade: 22 | DDD: 71 | Telefone: 999666666 | Salario: 2100.00
[07] ID: 7 | Nome: Gabriel      | Idade: 39 | DDD: 71 | Telefone: 999777777 | Salario: 5000.00
[08] ID: 8 | Nome: Helena       | Idade: 27 | DDD: 71 | Telefone: 999888888 | Salario: 3100.00
[09] ID: 9 | Nome: Igor         | Idade: 45 | DDD: 71 | Telefone: 999999999 | Salario: 6200.00
[10] ID: 10 | Nome: Julia        | Idade: 33 | DDD: 71 | Telefone: 998111111 | Salario: 3700.00
[11] ID: 11 | Nome: Kleber       | Idade: 29 | DDD: 71 | Telefone: 998222222 | Salario: 2900.00
[12] ID: 12 | Nome: Larissa      | Idade: 41 | DDD: 71 | Telefone: 998333333 | Salario: 4300.00
[13] ID: 13 | Nome: Marcos       | Idade: 26 | DDD: 71 | Telefone: 998444444 | Salario: 2700.00
[14] ID: 14 | Nome: Natalia      | Idade: 38 | DDD: 71 | Telefone: 998555555 | Salario: 5100.00
[15] ID: 15 | Nome: Otavio       | Idade: 24 | DDD: 71 | Telefone: 998666666 | Salario: 2300.00
[16] ID: 16 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[17] ID: 17 | Nome: Rafael       | Idade: 30 | DDD: 71 | Telefone: 998888888 | Salario: 3500.00
[18] ID: 18 | Nome: Sabrina      | Idade: 44 | DDD: 71 | Telefone: 998999999 | Salario: 5800.00
[19] ID: 19 | Nome: Thiago       | Idade: 32 | DDD: 71 | Telefone: 997111111 | Salario: 3900.00

DEPOIS DO VAO NO INDICE 8:
[00] ID: 1 | Nome: Ana          | Idade: 25 | DDD: 71 | Telefone: 999111111 | Salario: 2500.00
[01] ID: 2 | Nome: Bruno        | Idade: 31 | DDD: 71 | Telefone: 999222222 | Salario: 3200.00
[02] ID: 3 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[03] ID: -1 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[04] ID: 4 | Nome: Diana        | Idade: 28 | DDD: 71 | Telefone: 999444444 | Salario: 2800.00
[05] ID: 5 | Nome: Eduardo      | Idade: 35 | DDD: 71 | Telefone: 999555555 | Salario: 3900.00
[06] ID: 6 | Nome: Fernanda     | Idade: 22 | DDD: 71 | Telefone: 999666666 | Salario: 2100.00
[07] ID: 7 | Nome: Gabriel      | Idade: 39 | DDD: 71 | Telefone: 999777777 | Salario: 5000.00
[08] ID: -1 | Nome: Gabriel      | Idade: 39 | DDD: 71 | Telefone: 999777777 | Salario: 5000.00
[09] ID: 8 | Nome: Helena       | Idade: 27 | DDD: 71 | Telefone: 999888888 | Salario: 3100.00
[10] ID: 9 | Nome: Igor         | Idade: 45 | DDD: 71 | Telefone: 999999999 | Salario: 6200.00
[11] ID: 10 | Nome: Julia        | Idade: 33 | DDD: 71 | Telefone: 998111111 | Salario: 3700.00
[12] ID: 11 | Nome: Kleber       | Idade: 29 | DDD: 71 | Telefone: 998222222 | Salario: 2900.00
[13] ID: 12 | Nome: Larissa      | Idade: 41 | DDD: 71 | Telefone: 998333333 | Salario: 4300.00
[14] ID: 13 | Nome: Marcos       | Idade: 26 | DDD: 71 | Telefone: 998444444 | Salario: 2700.00
[15] ID: 14 | Nome: Natalia      | Idade: 38 | DDD: 71 | Telefone: 998555555 | Salario: 5100.00
[16] ID: 15 | Nome: Otavio       | Idade: 24 | DDD: 71 | Telefone: 998666666 | Salario: 2300.00
[17] ID: 16 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[18] ID: 17 | Nome: Rafael       | Idade: 30 | DDD: 71 | Telefone: 998888888 | Salario: 3500.00
[19] ID: 18 | Nome: Sabrina      | Idade: 44 | DDD: 71 | Telefone: 998999999 | Salario: 5800.00

DEPOIS DO VAO NO PENULTIMO INDICE:
[00] ID: 1 | Nome: Ana          | Idade: 25 | DDD: 71 | Telefone: 999111111 | Salario: 2500.00
[01] ID: 2 | Nome: Bruno        | Idade: 31 | DDD: 71 | Telefone: 999222222 | Salario: 3200.00
[02] ID: 3 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[03] ID: -1 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[04] ID: 4 | Nome: Diana        | Idade: 28 | DDD: 71 | Telefone: 999444444 | Salario: 2800.00
[05] ID: 5 | Nome: Eduardo      | Idade: 35 | DDD: 71 | Telefone: 999555555 | Salario: 3900.00
[06] ID: 6 | Nome: Fernanda     | Idade: 22 | DDD: 71 | Telefone: 999666666 | Salario: 2100.00
[07] ID: 7 | Nome: Gabriel      | Idade: 39 | DDD: 71 | Telefone: 999777777 | Salario: 5000.00
[08] ID: -1 | Nome: Gabriel      | Idade: 39 | DDD: 71 | Telefone: 999777777 | Salario: 5000.00
[09] ID: 8 | Nome: Helena       | Idade: 27 | DDD: 71 | Telefone: 999888888 | Salario: 3100.00
[10] ID: 9 | Nome: Igor         | Idade: 45 | DDD: 71 | Telefone: 999999999 | Salario: 6200.00
[11] ID: 10 | Nome: Julia        | Idade: 33 | DDD: 71 | Telefone: 998111111 | Salario: 3700.00
[12] ID: 11 | Nome: Kleber       | Idade: 29 | DDD: 71 | Telefone: 998222222 | Salario: 2900.00
[13] ID: 12 | Nome: Larissa      | Idade: 41 | DDD: 71 | Telefone: 998333333 | Salario: 4300.00
[14] ID: 13 | Nome: Marcos       | Idade: 26 | DDD: 71 | Telefone: 998444444 | Salario: 2700.00
[15] ID: 14 | Nome: Natalia      | Idade: 38 | DDD: 71 | Telefone: 998555555 | Salario: 5100.00
[16] ID: 15 | Nome: Otavio       | Idade: 24 | DDD: 71 | Telefone: 998666666 | Salario: 2300.00
[17] ID: 16 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[18] ID: -1 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[19] ID: 17 | Nome: Rafael       | Idade: 30 | DDD: 71 | Telefone: 998888888 | Salario: 3500.00

ALINHANDO ARRAY:
DEPOIS DO ALINHAMENTO:
[00] ID: 1 | Nome: Ana          | Idade: 25 | DDD: 71 | Telefone: 999111111 | Salario: 2500.00
[01] ID: 2 | Nome: Bruno        | Idade: 31 | DDD: 71 | Telefone: 999222222 | Salario: 3200.00
[02] ID: 3 | Nome: Carlos       | Idade: 42 | DDD: 71 | Telefone: 999333333 | Salario: 4500.00
[03] ID: 4 | Nome: Diana        | Idade: 28 | DDD: 71 | Telefone: 999444444 | Salario: 2800.00
[04] ID: 5 | Nome: Eduardo      | Idade: 35 | DDD: 71 | Telefone: 999555555 | Salario: 3900.00
[05] ID: 6 | Nome: Fernanda     | Idade: 22 | DDD: 71 | Telefone: 999666666 | Salario: 2100.00
[06] ID: 7 | Nome: Gabriel      | Idade: 39 | DDD: 71 | Telefone: 999777777 | Salario: 5000.00
[07] ID: 8 | Nome: Helena       | Idade: 27 | DDD: 71 | Telefone: 999888888 | Salario: 3100.00
[08] ID: 9 | Nome: Igor         | Idade: 45 | DDD: 71 | Telefone: 999999999 | Salario: 6200.00
[09] ID: 10 | Nome: Julia        | Idade: 33 | DDD: 71 | Telefone: 998111111 | Salario: 3700.00
[10] ID: 11 | Nome: Kleber       | Idade: 29 | DDD: 71 | Telefone: 998222222 | Salario: 2900.00
[11] ID: 12 | Nome: Larissa      | Idade: 41 | DDD: 71 | Telefone: 998333333 | Salario: 4300.00
[12] ID: 13 | Nome: Marcos       | Idade: 26 | DDD: 71 | Telefone: 998444444 | Salario: 2700.00
[13] ID: 14 | Nome: Natalia      | Idade: 38 | DDD: 71 | Telefone: 998555555 | Salario: 5100.00
[14] ID: 15 | Nome: Otavio       | Idade: 24 | DDD: 71 | Telefone: 998666666 | Salario: 2300.00
[15] ID: 16 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[16] ID: 17 | Nome: Rafael       | Idade: 30 | DDD: 71 | Telefone: 998888888 | Salario: 3500.00
[17] ID: -1 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[18] ID: -1 | Nome: Patricia     | Idade: 36 | DDD: 71 | Telefone: 998777777 | Salario: 4100.00
[19] ID: -1 | Nome: Rafael       | Idade: 30 | DDD: 71 | Telefone: 998888888 | Salario: 3500.00

thermius@arch: 

```
### 📄 Licença

Todos os direitos reservados.

Este projeto é disponibilizado exclusivamente para fins de portfólio e demonstração técnica. O código-fonte não pode ser copiado, redistribuído, modificado ou utilizado, integral ou parcialmente, sem autorização prévia e explícita do autor.
