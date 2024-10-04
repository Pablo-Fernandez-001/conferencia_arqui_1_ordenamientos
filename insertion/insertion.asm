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

    ; Imprimimos el arreglo original
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

    ; --- Implementación de ordenamiento por inserción ---
    mov si, offset array + 1            ; Empezamos desde el segundo elemento
    mov cx, array_len - 1               ; Número de elementos a ordenar

outer_loop_insertion:
    mov di, si                          ; Establecemos el puntero de inserción
    mov al, [si]                        ; Almacenamos el elemento actual en AL

inner_loop_insertion:
    cmp di, offset array                ; Verificamos si hemos llegado al principio
    jle end_inner_loop                  ; Si es así, terminamos el bucle interno
    cmp al, [di-1]                      ; Comparamos con el elemento anterior
    jge end_inner_loop                  ; Si ya está en orden, terminamos el bucle interno
    mov ah, [di-1]                      ; Desplazamos el elemento mayor una posición a la derecha
    mov [di], ah
    dec di                              ; Movemos el puntero de inserción una posición atrás
    jmp inner_loop_insertion

end_inner_loop:
    mov [di], al                        ; Insertamos el elemento actual en su posición ordenada
    inc si                              ; Pasamos al siguiente elemento
    loop outer_loop_insertion
    ; --- Fin de ordenamiento por inserción ---

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