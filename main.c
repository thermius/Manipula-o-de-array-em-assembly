#include <stdio.h>
#include <stdint.h>

/*declaração de função assembly*/
extern int MoverMemoria (int64_t*, int64_t*, int64_t*);
extern void AlinharArray (int64_t*,int64_t*);

int main ()
{

/*EXEMPLO: Alinhar array*/

  /*Cria uma array de 10*8 bytes*/
  int64_t array [10];

  /*Zera o array e cria um buraco no indice 0*/  
  for (int i = 0; i < 10; i++ )  array[i] = i;
  array [0] = -1;

  /*Exibe o antes*/
  printf ("Antes da chamada assembly para alinhar o array:\n");
  for (int i = 0; i < 10; i++ ) printf ("%i\n",array [i]);

  /*Alinha o array*/
  AlinharArray(&array[0], &array[9]);

  /*Exibe o depois*/
  printf ("Depois da chamada assembly:\n");
  for (int i = 0; i < 10; i++ ) printf ("%i\n",array [i]);


/*EXEMPLO: Mover Memoria para abri um vão*/

  /*Cria uma array de 10*8 bytes*/
  int64_t array2 [10];

  /*Inicializa o array e preenche com valores*/
  for (int i = 0; i < 10; i++ ) array2[i] = i*2;
  
  /*Exibe o antes*/
  printf ("Antes da chamada assembly para abri um vao:\n");
  for (int i = 0; i < 10; i++ )   printf ("%i\n",array2 [i]); 

  /*Abre um vão no indice 3*/
  MoverMemoria(&array2[0], &array2[9], &array2[3]);

  /*Exibe o depois*/
  printf ("Depois da chamada assembly para abri um vao:\n");
  for (int i = 0; i < 10; i++ )  printf ("%i\n",array2 [i]);
  
  return 0;
}
