.intel_syntax noprefix
.global MoverMemoria, AlinharArray

.text

MoverMemoria:
/*Descrição:

 * Desloca um bloco de 8 bytes memória para abrir um espaço entre elementos.
 *
 * Escrita em assembly devido à necessidade de controle preciso da memória e
 * para evitar cópias desnecessárias.
 *
 * Exemplo:
 *
 * Memória inicial:
 *   |10|25|40|80|
 *
 * Abrindo um espaço entre 25 e 40:
 *   |10|25|  |40|
 * Observe que, o ultimo elemento sempre é perdido. O lugar onde o vão é aberto recebe o valor -1
 * IMPORTATE: O dado sempre deve ter 8 bytes. Se isso não for respeitado, o resultado é indefinido.

Argumentos:
    1. Em RDI estará o endereço do indice 0 do array;
    2. Em RSI estará o endereço do ultimo indice do array;
    3. Em RDX estará o endereço onde o vão deve ser aberto;

 */

    /*Valida se haverá ou não estouro de memoria*/
    MOV R10, RDX           /*Carrega R10 com o endereço onde o vão vai ser aberto*/
    ADD R10, 8             /*Soma 8 em R10 para saber se irá ou não estourar a memoria*/
    CMP R10, RSI           /*Compara para saber se o vão irá estourar a memoria*/
    JG  FIM_ERRO           /*Se maior, haverá estouro. Salta para a rotina de erro*/

    /*Carrega para R10 o endereço do ultimo elemento do array*/
    MOV R10, RSI

  /*Copia os bytes efetivamente de 8 em 8*/
COPIA:
    SUB R10, 8                /*Subtrai 8 de R10, apontado para o penultino elemento*/
    MOV RAX, [R10]            /*Carrega RAX com o conteudo apontado por R10*/
    MOV [R10 + 8],  RAX       /*Copia os dados do penulimo elemento para o ultimo elemento, de forma a deslocar*/
    CMP R10, RDX              /*Compara com o endereço onde o vão deve ser aberto. Se menor ou igual, o vão já está aberto. Encerramos*/
    JLE FIM_SUCESSO_MOVER_MEMORIA
    JMP COPIA

FIM_ERRO:
    MOV RAX, -1             /*Retorna -1*/
    RET

FIM_SUCESSO_MOVER_MEMORIA:
    MOV QWORD PTR [R10], -1
    MOV RAX, 0              /*Retorna 0*/
    RET


AlinharArray:
/*

Descrição:
    Varre o array da esquerda para a direita procurando elementos vazios (buracos)
    e alinha a estrutura movendo os dados válidos para trás.

Funcionamento (Algoritmo de Borbulhamento):
    - O valor reservado como flag de buraco é o -1 (elemento sem uso).
    - Quando um buraco é encontrado, ele troca de lugar consecutivamente com
      os elementos à sua direita.
    - Esse processo "chuta" o buraco de -1 até a última posição física do array.

-------------------------------------------------------------------------------
Exemplo Visual 1 (Buraco no meio do array):
    Imagine que o índice 3 foi deletado e recebeu a flag -1.

    Antes da chamada:
    +----+----+----+----+----+----+----+----+----+----+
    | 10 | 20 | 30 | -1 | 50 | 60 | 70 | 80 | 90 |100 |
    +----+----+----+----+----+----+----+----+----+----+
      0    1    2    3    4    5    6    7    8    9   (Índices)
                     ^
                  Buraco!

    Depois da chamada (Alinhado):
    +----+----+----+----+----+----+----+----+----+----+
    | 10 | 20 | 30 | 50 | 60 | 70 | 80 | 90 |100 | -1 |
    +----+----+----+----+----+----+----+----+----+----+
      0    1    2    3    4    5    6    7    8    9   (Índices)
                                                   ^
                                            Buraco isolado no fim

Argumentos:
    1. Em RDI estará o endereço do indice 0 do array;
    2. Em RSI estará o endereço do ultimo indice do array;
*/

    MOV R8, RDI         /*Carrega R8 com o valor do inicio do array*/
    MOV R9, RSI         /*Carrega R9 com o valor do final do array*/

VERIFICAR:
    CMP R8, RSI
    JG  FIM_SUCESSO_ALINHAR_ARRAY
    MOV RAX, [R8]       /*Carrega RAX com o conteudo apontado por R8*/
    CMP RAX, -1         /*Verifica se é um burraco*/
    JE  DESLOCAR        /*Salta para a rotina que desloca se for buraco*/
    ADD R8, 8           /*Aponta R8 para o proximo elemento*/
    JMP VERIFICAR

DESLOCAR:
    MOV R11, R8         /*Carrega R11 com R8*/
    ADD R11, 8          /*Aponta R11 para o proximo elemento do array*/
    CMP R11, RSI        /*Verifica se R8 está apontado para fora do array*/
    JG FIM_ERRO         /*Se sim, finaliza com erro pois o usuario tentou deslocar o ultimo elemento do array.*/
    MOV R10, [R11]      /*Carrega R10 com o proximo elemento do array*/
    MOV [R8], R10       /*Trás o elemento a frente de N para o endereço de N*/
    MOV QWORD PTR [R11], -1 /*Marca o proximo elemento do array como -1 pois ele foi movido para a posição anterior.*/
    ADD R8, 8           /*Aponta R8 para o proximo elemento, que será o proximo buraco*/
    JMP VERIFICAR

FIM_SUCESSO_ALINHAR_ARRAY:
    MOV RAX, 0              /*Retorna 0*/
    RET
