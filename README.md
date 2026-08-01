# Manipula-o-de-array-em-assembly
Manipulação eficiente de arrays em Assembly x86-64 puro.  Duas rotinas: AlinharArray (elimina buracos) e MoverMemoria (abre vões).  Demonstra domínio de assembly, ponteiros e otimização de memória.
# Manipulação de Arrays em Assembly x86-64

Duas rotinas otimizadas em **assembly puro** para manipulação eficiente de arrays com controle preciso de memória.

## 🎯 O Que É

Este projeto implementa dois algoritmos críticos de manipulação de memória em **assembly x86-64** (sintaxe Intel), sem usar nenhuma biblioteca de alto nível. Código compilado direto para máquina, sem abstrações.

**Por que assembly?**
- Controle absoluto sobre registradores e memória
- Zero overhead de função (sem call stack desnecessário)
- Operações bit a bit e byte a byte precisas
- Ideal para otimizar estruturas de dados críticas

## 🏗️ Duas Funções Principais

### 1. **AlinharArray** — Elimina buracos do array

**O que faz:**
Varre um array procurando por elementos marcados como `-1` (buracos/vazios) e os empurra para o final, compactando os dados válidos.

**Algoritmo (Borbulhamento):**
1. Percorre o array da esquerda pra direita
2. Quando encontra `-1`, pega o elemento à direita
3. Move esse elemento pra posição do buraco
4. Marca a posição antiga com `-1`
5. Continua até o fim

**Assinatura:**
```c
extern void AlinharArray(int64_t *inicio, int64_t *fim);
```

**Parâmetros:**
- `RDI` (1º arg): endereço do primeiro elemento (`&array[0]`)
- `RSI` (2º arg): endereço do último elemento (`&array[tamanho-1]`)

**Retorno:**
- Nenhum (modifica o array in-place)

**Exemplo Visual:**

```
Antes:
+----+----+----+----+----+----+----+----+----+----+
| -1 | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  |
+----+----+----+----+----+----+----+----+----+----+

Depois (array alinhado):
+----+----+----+----+----+----+----+----+----+----+
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | -1 |
+----+----+----+----+----+----+----+----+----+----+
```

---

### 2. **MoverMemoria** — Abre um vão no array

**O que faz:**
Desloca elementos de um array para abrir um espaço (vão) em uma posição específica. Útil para inserir dados sem sobrescrever existentes.

**Algoritmo (Deslocamento Progressivo):**
1. Começa do último elemento
2. Copia cada elemento 8 bytes pra frente
3. Para quando atinge a posição do vão
4. Marca o vão com `-1` (flag de buraco)
5. O último elemento é perdido (sacrificado)

**Assinatura:**
```c
extern int MoverMemoria(int64_t *inicio, int64_t *fim, int64_t *vao);
```

**Parâmetros:**
- `RDI` (1º arg): endereço do primeiro elemento (`&array[0]`)
- `RSI` (2º arg): endereço do último elemento (`&array[tamanho-1]`)
- `RDX` (3º arg): endereço onde abrir o vão (`&array[posicao]`)

**Retorno:**
- `RAX = 0`: sucesso
- `RAX = -1`: erro (vão tentaria estourar memória)

**Exemplo Visual:**

```
Antes (array cheio):
+----+----+----+----+----+----+----+----+----+----+
| 0  | 2  | 4  | 6  | 8  | 10 | 12 | 14 | 16 | 18 |
+----+----+----+----+----+----+----+----+----+----+
 0    1    2    3    4    5    6    7    8    9

Abrindo vão no índice 3:

Depois:
+----+----+----+----+----+----+----+----+----+----+
| 0  | 2  | 4  | -1 | 6  | 8  | 10 | 12 | 14 | 16 |
+----+----+----+----+----+----+----+----+----+----+
 0    1    2    3    4    5    6    7    8    9
             ^
          Vão aberto
          (marcado com -1, último elemento 18 foi perdido)
```

---

## 💻 Como Compilar

**Arquivo assembly:** `mover_memoria.s`  
**Arquivo C:** `main.c`

```bash
gcc main.c mover_memoria.s -o programa
./programa
```

Pronto! Sem flags especiais, sem bibliotecas externas.

---

## 🧪 Teste em Execução

```
$ ./programa

Antes da chamada assembly para alinhar o array:
-1
1
2
3
4
5
6
7
8
9

Depois da chamada assembly:
1
2
3
4
5
6
7
8
9
-1

Antes da chamada assembly para abri um vao:
0
2
4
6
8
10
12
14
16
18

Depois da chamada assembly para abri um vao:
0
2
4
-1
6
8
10
12
14
16

**Vão aberto no índice 3, marcado com -1**
```

**O que aconteceu:**

1. **AlinharArray**: buraco no índice 0 foi empurrado pro final
2. **MoverMemoria**: vão aberto no índice 3, elementos deslocados pra direita, último elemento perdido

---

## 📊 Detalhes Técnicos

### Convenções de Chamada (ABI Linux x86-64)

Os argumentos são passados em registradores (não na pilha):

| Argumento | Registrador |
|-----------|------------|
| 1º | RDI |
| 2º | RSI |
| 3º | RDX |
| Retorno | RAX |

### Registradores Usados

- **R8, R9**: índices de iteração
- **R10, R11**: endereços temporários
- **RAX**: valor carregado, retorno da função
- **RDX**: endereço do vão (entrada), comparação

### Tamanho dos Dados

**Tudo é 8 bytes (64 bits)**, correspondente a `int64_t`:
- `ADD R8, 8` → próximo elemento
- `SUB R10, 8` → elemento anterior
- `MOV [R8], R10` → copia 8 bytes

Se mudar o tamanho dos dados, ajuste todos os offsets de 8 bytes.

---

## 🔬 Conceitos Demonstrados

- ✅ Aritmética de ponteiros em assembly
- ✅ Desreferência de memória (`MOV RAX, [R10]`)
- ✅ Loops e labels (VERIFICAR, COPIA, DESLOCAR)
- ✅ Comparação e saltos condicionais (CMP, JG, JLE, JE)
- ✅ Validação de bounds (verificar se vai estourar memória)
- ✅ Retorno de valores (RAX)
- ✅ Sintaxe Intel assembly (`.intel_syntax noprefix`)

---

## 📚 Referências

- **Intel x86-64 ISA Manual** — Referência de instruções
- **System V AMD64 ABI** — Convenções de chamada Linux

---

## 🎓 Conhecimentos Demonstrados

- ✅ Assembly x86-64 proficiente
- ✅ Manipulação direta de memória
- ✅ Otimização de baixo nível
- ✅ Interfaces C↔Assembly
- ✅ Debugging e validação de bounds
- ✅ Documentação clara de código assembly

---

## 📝 Limitações & Notas

- Dados devem ter **exatamente 8 bytes** (int64_t)
- Arrays devem estar **contíguos em memória**
- Flag de buraco/vão: **-1**
  - Tanto `AlinharArray` quanto `MoverMemoria` usam `-1` como marcador
  - Permite que as duas funções trabalhem juntas
- `AlinharArray` processa **um buraco por chamada**
  - Para múltiplos buracos consecutivos, chamar novamente
- `MoverMemoria` **perde o último elemento** ao abrir vão
  - Isso permite abrir espaço sem realocar a memória

---

## 📄 Licença

© 2026. Todos os direitos reservados.  
Este código é fornecido apenas para fins de portfólio. Nenhuma cópia, distribuição ou uso sem permissão explícita.

---

**Desenvolvido como estudo profundo de assembly x86-64 e otimização de estruturas de dados.**
