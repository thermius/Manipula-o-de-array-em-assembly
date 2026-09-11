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
    4. Em RCX estará o tamanho do dado
 */

    /*Verifições de logica*/
    CMP RDI, RSI
    JE FIM_ERRO_TAMANHO             /*Se array unitário, retorna*/
    CMP RDX, RSI    
    JE FIM_ERRO_TAMANHO             /*Se tentar abri vão no ultimo indice, retorna*/

    TEST RCX, 7                     /*Verifica se o tamanho do dado é multiplo de 8*/
    JNZ FIM_ERRO_TAMANHO
    MOV R9, RCX                     /*Salva o tamanho dado*/
    SHR RCX, 3                      /*Divide o tamanho por 8 para encontrar quantas vezes MOVQ deve-se repetir*/

LOOP_DESLOCAR:
    SUB RSI,R9                      /*Aponta RSI para o PENULTIMO elemento*/
    MOV R8, RSI                     /*R8 e RSI apontam para o penultimo elemento*/
    ADD R8, R9                      /*Aponta R8 para o ULTIMO elemento*/

    MOV RDI, R8                     /*Destino da copia*/
    MOV RSI, RSI                    /*Origem da copia. INUTIL. Somente coloquei pra formalizar como REP e MOVQ funcionam*/
    MOV RCX, RCX                    /*Quantas vezes repetir a copia. INUTIL. Somente coloquei pra formalizar como REP e MOVQ funcionam*/
    PUSH RSI                        /*Salva RSI*/
    REP MOVSQ                       /*Copia de 8 em 8 a quantidade de vezes em RCX e avança RSI. RCX fica zerado ao finalizar*/
    POP RSI                         /*Recupera RSI*/
    CMP RSI, RDX                     
    JL FIM_SUCESSO_MOVER_TAMANHO
    MOV RCX, R9                     /*Recupera RCX*/
    SHR RCX, 3                      /*Divide o tamanho por 8 para encontrar quantas vezes MOVQ deve-se repetir*/                
    JMP LOOP_DESLOCAR

FIM_SUCESSO_MOVER_TAMANHO:
    ADD RSI, R9
    MOV QWORD PTR [RSI], -1
    MOV RAX, 0
    RET



AlinharArray:

/*
Argumentos:
    1. Em RDI estará o endereço do indice 0 do array;
    2. Em RSI estará o endereço do ultimo indice do array;
    3. Em RDX estará o tamanho do dado a ser deslocado;
    Limitação atual: não verifica se o tamanho do dado informado é multiplo de 8
*/  
    
    /*Verificamos se o tamanho do dado é multiplo de 8 por meio do modulo da divisão*/
    TEST RDX, 7                 /*Verifica se o tamanho do dado é multiplo de 8*/
    JNZ FIM_ERRO_TAMANHO

    PUSH RBX                    /*Called saved*/
    PUSH R15                    /*Called saved*/

ALINHAR_ARRAY:
    CMP RDI, RSI                /*Se tentar alinhar array de um unico elemento, retorna*/
    JGE FIM_ERRO_ALINHAR        /*Retorna erro*/
    MOV R8, [RDI]               /*Carrega R8 com o conteudo apontado por RDI*/
    CMP R8, -1                  /*Verifica se R8 é um burraco*/
    JE DESLOCAMENTO             /*Se burraco, vai pra rotina que desloca*/
    ADD RDI, RDX                /*Se não for burraco avança RDI o tamanho do dado*/
    JMP ALINHAR_ARRAY           /*Repete o algoritmo*/

DESLOCAMENTO:
    MOV R10, 0                  /*Contador de descolamento de memoria*/
    MOV RAX, RDI                /*Carrega RAX com o endereço de memoria onde o burraco foi encontrado*/

REPETIR_ALINHAMENTO:
    MOV RBX, RAX                /*Carrega RBX com RAX*/

AVANCAR_RBX_SALVANDO:
    ADD RBX, RDX                /*Avança RBX*/
    MOV R15, RSI                /*Calcula o endereço onde estoura o array*/
    ADD R15, RDX                /*Calcula o endereço onde estoura o array*/
    CMP RBX, R15
    JE FIM_SUCESSO              /*Se chegar ao fim do array, já estamos alinhado*/
    MOV R8, [RBX]               /*Carrega R8 com o conteudo apontado por RBX*/
    CMP R8, -1          
    JE AVANCAR_RBX_SALVANDO     /*Avança RBX se burraco*/
    MOV R9, RBX                 /*Salva RBX em R9*/
    JMP MOVER_BYTES             /*Salta pra rotina que move os bytes*/

AVANCAR_RBX_SEM_SALVAR:
    ADD RBX, RDX                /*Avança RBX*/
    MOV R15, RSI                /*Calcula o endereço onde estoura o array*/
    ADD R15, RDX                /*Calcula o endereço onde estoura o array*/
    CMP RBX, R15
    JE FIM_SUCESSO              /*Se chegar ao fim do array, já estamos alinhado*/
    MOV R8, [RBX]               /*Carrega R8 com o conteudo apontado por RBX*/
    CMP R8, -1          
    JE AVANCAR_RBX_SEM_SALVAR   /*Avança RBX se burraco*/

MOVER_BYTES:
    
    PUSH RSI
    PUSH RDI
    MOV RSI, RBX                /*Preparação de MOVSQ*/
    MOV RDI, RAX                /*Preparação de MOVSQ*/
    MOV RCX, RDX                /*Preparação de MOVSQ*/
    SHR RCX, 3                  /*Preparação de MOVSQ*/
    REP MOVSQ
    POP RDI
    POP RSI
    MOV QWORD PTR [RBX], -1     /*Adciona um burraco no lugar onde foi copiado*/
    INC R10                     /*Contabiliza o deslocamento*/   
    ADD RAX, RDX                /*Avança RAX*/
    CMP RAX, R9         
    JE REPETIR_ALINHAMENTO
    JMP AVANCAR_RBX_SEM_SALVAR

FIM_SUCESSO:
    POP R15
    POP RBX
    MOV RAX, R10                    /*Retorna a quantidade de deslocamentos realizadas*/
    RET

FIM_ERRO_ALINHAR:
    POP R15
    POP RBX

FIM_ERRO_TAMANHO:
    MOV RAX, -1
    RET
