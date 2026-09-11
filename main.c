#include <stdio.h>
#include <stdint.h>

#define TAM_ARRAY 20

typedef struct {
    int64_t id;
    int32_t idade;
    int32_t ddd;
    int64_t telefone;
    char nome[32];
    double salario;
} Pessoa;

extern  int64_t AbrirVao        (void *, void *, void *, size_t);
extern  int64_t AlinharArray    (void *, void *,size_t); 
void    ExibirPessoas           (Pessoa *);


int main(void)
{
    int64_t array [TAM_ARRAY];
    /*Zera o array e cria um buraco no indice 0*/  
    for (int i = 0; i < TAM_ARRAY; i++ )  array[i] = i*10 + 1;

    /*Exibe o antes*/
    printf ("Antes da chamada assembly para ABRIR UM VÃO:\n");
    for (int i = 0; i < TAM_ARRAY; i++ ) printf ("%i\n",array [i]);

    /*Abre um vão no indice 3*/
    AbrirVao((void*)&array[0], (void*) &array[TAM_ARRAY -1], &array[3], sizeof (int64_t));
    printf ("Vão aberto no incide 3:\n");
    for (int i = 0; i < TAM_ARRAY; i++ ) printf ("%i\n",array [i]);

    /*Abre um vão no indice 8*/
    AbrirVao((void*) &array[0], (void*) &array[TAM_ARRAY -1], (void*) &array[8], sizeof (int64_t));
    printf ("Vão aberto no incide 8:\n");
    for (int i = 0; i < TAM_ARRAY; i++ ) printf ("%i\n",array [i]);      

    /*Abre um vão no penultimo indice*/
    AbrirVao((void*) &array[0], (void*) &array[TAM_ARRAY -1], (void*)&array[TAM_ARRAY - 2], sizeof (int64_t));
    printf ("Vão aberto no incide penultimo indice:\n");
    for (int i = 0; i < TAM_ARRAY; i++ ) printf ("%i\n",array [i],  sizeof (int64_t));      

    /*Alinhando o array*/
    printf ("\nChamando assembly para alinhar array\n");
    AlinharArray((void*)&array[0], (void*) &array[TAM_ARRAY-1], sizeof (int64_t));
    printf ("Array alinhado:\n");
    for (int i = 0; i < TAM_ARRAY; i++ ) printf ("%i\n",array [i],  sizeof (int64_t));


    printf ("\n*********************Demostração de estrutura complexa***********************\n\n");
    Pessoa pessoas[TAM_ARRAY] = {
        {1,  25, 71, 999111111, "Ana",    2500.00},
        {2,  31, 71, 999222222, "Bruno",  3200.00},
        {3,  42, 71, 999333333, "Carlos", 4500.00},
        {4,  28, 71, 999444444, "Diana",  2800.00},
        {5,  35, 71, 999555555, "Eduardo",3900.00},
        {6,  22, 71, 999666666, "Fernanda",2100.00},
        {7,  39, 71, 999777777, "Gabriel",5000.00},
        {8,  27, 71, 999888888, "Helena", 3100.00},
        {9,  45, 71, 999999999, "Igor",   6200.00},
        {10, 33, 71, 998111111, "Julia",  3700.00},
        {11, 29, 71, 998222222, "Kleber",2900.00},
        {12, 41, 71, 998333333, "Larissa",4300.00},
        {13, 26, 71, 998444444, "Marcos", 2700.00},
        {14, 38, 71, 998555555, "Natalia",5100.00},
        {15, 24, 71, 998666666, "Otavio", 2300.00},
        {16, 36, 71, 998777777, "Patricia",4100.00},
        {17, 30, 71, 998888888, "Rafael", 3500.00},
        {18, 44, 71, 998999999, "Sabrina",5800.00},
        {19, 32, 71, 997111111, "Thiago", 3900.00},
        {20, 37, 71, 997222222, "Vanessa",4700.00}
    };
    printf("Tamanho da struct: %zu bytes\n\n", sizeof(Pessoa));
    printf("ANTES:\n");
    ExibirPessoas(pessoas);

    /*Abre um vão no índice 3*/
    AbrirVao(&pessoas[0],&pessoas[TAM_ARRAY - 1], &pessoas[3], sizeof(Pessoa));

    printf("DEPOIS DO VAO NO INDICE 3:\n");
    ExibirPessoas(pessoas);

    /* Abre outro vão no índice 8 */
    AbrirVao( &pessoas[0],&pessoas[TAM_ARRAY - 1], &pessoas[8], sizeof(Pessoa));

    printf("DEPOIS DO VAO NO INDICE 8:\n");
    ExibirPessoas(pessoas);

    /* Abre um vão no penúltimo índice */
    AbrirVao(&pessoas[0], &pessoas[TAM_ARRAY - 1], &pessoas[TAM_ARRAY - 2], sizeof(Pessoa));

    printf("DEPOIS DO VAO NO PENULTIMO INDICE:\n");
    ExibirPessoas(pessoas);

    /* Alinha */
    printf("ALINHANDO ARRAY:\n");

    AlinharArray( &pessoas[0], &pessoas[TAM_ARRAY - 1], sizeof(Pessoa) );

    printf("DEPOIS DO ALINHAMENTO:\n");
    ExibirPessoas(pessoas);    
    return 0;
}


void ExibirPessoas (Pessoa *array)
{
    for (int i = 0; i < TAM_ARRAY; i++) {
        printf(
            "[%02d] ID: %ld | Nome: %-12s | Idade: %d | DDD: %d | Telefone: %ld | Salario: %.2f\n",
            i,
            array[i].id,
            array[i].nome,
            array[i].idade,
            array[i].ddd,
            array[i].telefone,
            array[i].salario
        );
    }

    printf("\n");
}
