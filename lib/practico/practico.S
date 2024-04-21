/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros R0 a R12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros R0 a R3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros R0 a R3 y el
 * registro R12 pueden cambiar su valor (y en particular, R0 contiene 
 * normalmente el valor devuelto), los registros R4 a R11 preservan
 * su valor.
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * Sumar dos enteros de 32 bit
 *  suma(2,3) => 5
 * Entrada
 *  a->R0, b->R1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  R0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}
   
    add R0,R1

    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->R0    : Cantidad de números en registro R0, entero de 32 bit
 *  b->R1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  R1:R0 : Sumatoria, entero de 64 bit con signo 
 */
defun sumatoria
    push {r4-r11,lr}

    mov r2,R0
    mov r3,r1
    mov r0,#0
    mov r1,#0
    mov r4,#0

A:
    cmp r4,r2
    bge B
    ldr r5,[r3,r4,lsl#2]
    add r0,r5
    adc r1,#0
    add r4,#1
    bal A

B:
    pop {r4-r11,pc}
endfun sumatoria

/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->R0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  R0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */
defun posicion_maximo
    push {r4-r11,lr}

    mov r2,r0 /*n=r2*/
    mov r3,r1 /*b=r3*/
    
    mov r4,#0

    cmp r2,#1 /*comparo n con 1*/
    bls E /*n<=1 entonces salta a B q retorna k=r4*/
    ldr r5,[r3,r4,lsl#2]
    mov r6,#1
D:
    cmp r6,r2
    bhs E
    ldr r7,[r3,r6,lsl#2]
    cmp r5,r7
    bge C
    
    mov r5,r7
    mov r4,r6

C:
    add r6,#1
    bal D

E:
    mov r0,r4
    pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7};
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->R0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    
    mov r2,r0 /* saco de r0 xq despues se usa ro en la subrutina*/
    mov r3,r1

    sub r4,r2,#1

F:
    cmp r2,#0
    bls G

    add r4,#1
    posicion_maximo(r4,r3) /* devuelve en r0*/
    mov r5,r0

    sub r4,#1
    ldr r6,[r3,r4,lsl#2]

    ldr r7,[r3,r5,lsl#2] /* llevo a un auxiliar bj */
    str r7,[r3,r4,lsl#2] /* llevo a auxiliar a bk */

    str r6,[r3,r5,lsl#2]

    sub r4,#1

    bal F


G:
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
