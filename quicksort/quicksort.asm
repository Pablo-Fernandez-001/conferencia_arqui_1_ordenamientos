.model small
.stack 100h
.data
array db 1, 7, 5, 2, 3, 6, 4, 9, 8, 10
array_len equ $-array
msg1 db 'Arreglo original: $', 0Dh, 0Ah, '$'
msg2 db 'Arreglo ordenado: $', 0Dh, 0Ah, '$'

.code
start:
    mov ax, @data
    mov ds, ax

    ; Imprimimos el arreglo original
    mov dx, offset msg1
    mov ah, 09h
    int 21h
    mov si, offset array
    mov cx, array_len
print_original:
    mov al, [si]          ; Cargamos el número en AL
    call print_number     ; Llamamos a la subrutina para imprimir el número
    mov dl, ' '           ; Imprimimos un espacio
    mov ah, 02h
    int 21h
    inc si                 ; Pasamos al siguiente número
    loop print_original

    ; --- Implementación de Quicksort ---
    mov si, offset array   ; Apuntamos al principio del arreglo
    mov cx, array_len - 1  ; Longitud del arreglo (índice del último elemento)
    push cx                ; Empujamos la longitud del arreglo a la pila
    push si                ; Empujamos la dirección del arreglo a la pila
    call quicksort         ; Llamamos a la función quicksort

    ; --- Fin de Quicksort ---

    ; Imprimimos el arreglo ordenado
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    mov si, offset array
    mov cx, array_len
print_sorted:
    mov al, [si]          ; Cargamos el número en AL
    call print_number     ; Llamamos a la subrutina para imprimir el número
    mov dl, ' '           ; Imprimimos un espacio
    mov ah, 02h
    int 21h
    inc si                 ; Pasamos al siguiente número
    loop print_sorted

    ; Salimos del programa
    mov ah, 4Ch
    int 21h

; Subrutina para imprimir un número en AL
print_number:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0   ; Limpiamos AH para la división
    mov bl, 10  ; Base 10
    xor cx, cx  ; Contador de dígitos = 0

convert_loop:
    div bl       ; Dividimos AX por 10
    push ax      ; Guardamos AX en la pila
    inc cx       ; Incrementamos el contador de dígitos
    cmp al, 0    ; Verificamos si el cociente es cero
    jne convert_loop

print_digits:
    pop ax       ; Obtenemos el dígito de la pila
    add ah, '0'  ; Convertimos a ASCII
    mov dl, ah   ; Preparamos para imprimir
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Subrutina Quicksort
quicksort:
    push bp
    mov bp, sp
    sub sp, 4  ; Asignamos espacio para variables locales
    push si
    push di

    mov si, [bp+4]  ; Dirección del arreglo
    mov cx, [bp+6]  ; Longitud del arreglo (último índice)
    cmp si, cx
    jge quicksort_end

    ; Particionamos el arreglo
    call partition
    mov di, ax      ; Índice del pivote

    ; Ordenamos recursivamente la partición izquierda
    push si         ; Inicio de la partición izquierda
    push di         ; Fin de la partición izquierda
    dec di
    call quicksort

    ; Ordenamos recursivamente la partición derecha
    push di         ; Inicio de la partición derecha
    inc di
    push cx         ; Fin de la partición derecha
    call quicksort

quicksort_end:
    add sp, 4  ; Desasignamos espacio para variables locales
    pop di
    pop si
    pop bp
    ret

; Subrutina para particionar el arreglo
partition:
    push bp
    mov bp, sp
    sub sp , 4  ; Asignamos espacio para variables locales
    push si
    push di

    mov si, [bp+4]  ; Inicio del arreglo
    mov cx, [bp+6]  ; Fin del arreglo
    mov di, si      ; Índice del pivote
    mov al, [si]    ; Elemento pivote en AL

    mov bx, cx      ; Fin del arreglo para la comparación

partition_loop:
    cmp si, bx
    jge partition_done

    ; Movemos los punteros para encontrar elementos desordenados
    ; Movemos si a la derecha mientras array[si] < pivote
    find_left:
        cmp byte ptr [si], al  ; Comparación explícita de bytes
        jge find_right
        inc si
        jmp find_left

    ; Movemos bx a la izquierda mientras array[bx] > pivote
    find_right:
        cmp byte ptr [bx], al ; Comparación explícita de bytes
        jle skip_swap
        dec bx
        jmp find_right

    ; Intercambiamos elementos
    skip_swap:
    cmp si, bx
    jge partition_done
    mov dl, [si]  ; Cargamos valor de [si] en DL
    mov dh, [bx]  ; Cargamos valor de [bx] en DH
    mov [si], dh  ; Almacenamos valor de DH en [si]
    mov [bx], dl  ; Almacenamos valor de DL en [bx]

    jmp partition_loop

partition_done:
    ; Colocamos el pivote en su posición correcta
    mov dl, [si]  ; Cargamos valor de [si] en DL
    mov dh, [di]  ; Cargamos valor de [di] en DH
    mov [si], dh  ; Almacenamos valor de DH en [si]
    mov [di], dl  ; Almacenamos valor de DL en [di]
    mov ax, si        ; Devolvemos índice del pivote
    add sp, 4  ; Desasignamos espacio para variables locales
    pop di
    pop si
    pop bp
    ret

end start