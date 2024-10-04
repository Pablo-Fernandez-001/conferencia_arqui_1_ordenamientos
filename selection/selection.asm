.model small
.stack 100h

.data
array db 1, 5, 7, 2, 3, 6, 4, 9, 8, 10
array_len equ $-array
msg1 db 'Arreglo original: $'
msg2 db 'Arreglo ordenado: $'
space db ' '

.code
start:
    mov ax, @data                       ; Obtenemos los datos
    mov ds, ax                          ; Movemos los datos al segmento de datos

    mov dx, offset msg1                 ; Imprimimos el primer mensaje con los datos y su respectiva 
    mov ah, 09h                         ; creamos las interrupciones necesarias para imprimir
    int 21h

    mov si, offset array                ; Impresión del array
    mov cx, array_len                   ; Obtenemos el tamaño del arreglo

print_original:
    mov al, [si]                        ; Cargamos el número en AL
    call print_number                   ; Llamamos a la subrutina para imprimir el número
    mov dl, ' '                         ; Imprimimos un espacio
    mov ah, 02h
    int 21h
    inc si                              ; Pasamos al siguiente número
    loop print_original                 ; Realizamos el loop hasta que terminen todos los números

    ; --- Implementación de ordenamiento por selección ---    
    mov si, offset array                ; Empezamos desde el primer elemento
    mov cx, array_len - 1               ; Número de pasadas
outer_loop_selection:
    mov di, si                          ; Establecemos el índice mínimo
    mov bx, si                          ; Establecemos el puntero del bucle interno

inner_loop_selection:
    inc bx                              ; Pasamos al siguiente elemento
    cmp bx, offset array + array_len    ; Verificamos si hemos llegado al final
    jge end_inner_loop_selection        ; Si es así, terminamos el bucle interno
    mov al, [bx]                        ; Cargamos el elemento actual
    cmp al, [di]                        ; Comparamos con el elemento mínimo actual
    jge inner_loop_selection            ; Si no es menor, continuamos
    mov di, bx                          ; Actualizamos el índice mínimo
    jmp inner_loop_selection

end_inner_loop_selection:
    ; Intercambiamos el elemento mínimo con el primer elemento de la porción no ordenada
    mov al, [di]                        ; Cargamos el elemento mínimo
    xchg al, [si]                       ; Intercambiamos valores directamente en memoria
    mov [di], al                        ; 
    inc si                              ; Pasamos al siguiente elemento
    loop outer_loop_selection
    ; --- Fin de ordenamiento por selección ---

    ; Imprimimos el arreglo ordenado
    mov dx, offset msg2                 ; Mostramos el segundo mensaje ya ordenado
    mov ah, 09h                         ; creamos las interrupciones necesarias para imprimir
    int 21h
    mov si, offset array                ; mostramos el arreglo ya ordenado
    mov cx, array_len                   ; actualizamos el tamaño
print_sorted:
    mov al, [si]                        ; Cargamos el número en AL
    call print_number                   ; Llamamos a la subrutina para imprimir el número
    mov dl, ' '                         ; Imprimimos un espacio
    mov ah, 02h                         ; Interrupciones necesarias para imprimir el espacio
    int 21h
    inc si                              ; Pasamos al siguiente número
    loop print_sorted                   ; Realizamos el loop hasta que terminen todos los números

    ; Salimos del programa
    mov ah, 4Ch
    int 21h

; Subrutina para imprimir un número en AL
print_number:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0                            ; Limpiamos AH para la división
    mov bl, 10                           ; Base 10
    xor cx, cx                           ; Contador de dígitos = 0

convert_loop:
    div bl                               ; Dividimos AX entre 10
    push ax                              ; Guardamos AX en la pila
    inc cx                               ; Incrementamos el contador de dígitos
    cmp al, 0                            ; Verificamos si el cociente es cero
    jne convert_loop

print_digits:
    pop ax                               ; Obtenemos el dígito de la pila
    add ah, '0'                          ; Convertimos a ASCII
    mov dl, ah                           ; Preparamos para imprimir
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret

end start