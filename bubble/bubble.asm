.model small
.stack 100h
.data
array db 1 , 7 , 5, 2, 3, 6, 4, 9, 8, 10
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

    ; --- Implementación de ordenamiento por burbuja ---
    mov cx, array_len                   ; Contador de bucle exterior (número de pasadas)
outer_loop:
    push cx                             ; Guardamos el contador de bucle exterior
    mov si, offset array                ; Apuntamos al principio del arreglo
    mov cx, array_len - 1               ; Contador de bucle interior (comparaciones en una pasada)

inner_loop:
    mov al, [si]                        ; Cargamos el elemento actual
    
    ; if curr_pos <= nex_pos
    cmp al, [si+1]                      ; Comparamos con el elemento siguiente
    jle no_swap                         ; Saltamos si está en orden (menor o igual)


    ; else: Intercambiamos elementos
    xchg al, [si+1]                     ; cambiamos el dato dentro de la siguiente posición
    mov [si], al                        ; colocamos el dato de al dentro de si

no_swap:
    inc si                              ; Pasamos a la siguiente pareja
    loop inner_loop                     ; Realizamos el loop hasta que terminen todos los números

    pop cx                              ; Restauramos el contador de bucle exterior
    loop outer_loop                     ; Realizamos el loop hasta que terminen todos los números

    ; --- Fin de ordenamiento por burbuja ---

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