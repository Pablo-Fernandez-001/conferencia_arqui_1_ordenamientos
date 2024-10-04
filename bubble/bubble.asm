.model small
.stack 100h
.data
array db 1 , 7 , 5, 2, 3, 6, 4, 9, 8, 10
array_len equ $-array
msg1 db 'Original array: $'
msg2 db 'Sorted array: $'
space db ' '

.code
start:
    mov ax, @data
    mov ds, ax

    ; print original array
    mov dx, offset msg1
    mov ah, 09h
    int 21h
    mov si, offset array
    mov cx, array_len
print_original:
    mov al, [si]          ; Load number into AL
    call print_number     ; Call subroutine to print the number
    mov dl, ' '          ; Print a space
    mov ah, 02h
    int 21h
    inc si                 ; Move to the next number
    loop print_original

    ; --- Bubble Sort Implementation ---
    mov cx, array_len     ; Outer loop counter (number of passes)
outer_loop:
    push cx                ; Save outer loop counter
    mov si, offset array   ; Point to the beginning of the array
    mov cx, array_len - 1 ; Inner loop counter (comparisons in a pass)

inner_loop:
    mov al, [si]           ; Load current element
    cmp al, [si+1]        ; Compare with the next element
    jle no_swap           ; Jump if in order (less than or equal)

    ; Swap elements
    xchg al, [si+1]        ; Exchange values directly in memory
    mov [si], al           ; 

no_swap:
    inc si                  ; Move to the next pair
    loop inner_loop

    pop cx                 ; Restore outer loop counter
    loop outer_loop

    ; --- End of Bubble Sort ---

    ; print sorted array
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    mov si, offset array
    mov cx, array_len
print_sorted:
    mov al, [si]          ; Load number into AL
    call print_number     ; Call subroutine to print the number
    mov dl, ' '          ; Print a space
    mov ah, 02h
    int 21h
    inc si                 ; Move to the next number
    loop print_sorted

    ; exit program
    mov ah, 4Ch
    int 21h

; Subroutine to print a number in AL
print_number:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0   ; Clear AH for division
    mov bl, 10  ; Base 10
    xor cx, cx  ; Digit counter = 0

convert_loop:
    div bl       ; Divide AX by 10
    push ax      ; Save AX on the stack
    inc cx      ; Increment digit counter
    cmp al, 0   ; Check if quotient is zero
    jne convert_loop

print_digits:
    pop ax      ; Get digit from stack
    add ah, '0' ; Convert to ASCII
    mov dl, ah  ; Prepare for printing
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret

end start