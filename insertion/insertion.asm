.model small
.stack 100h

.data
array db 1, 5, 7, 2, 3, 6, 4, 9, 8, 10
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
    mov al, [si] 
    call print_number
    mov dl, ' ' 
    mov ah, 02h
    int 21h
    inc si 
    loop print_original

    ; --- Insertion Sort Implementation ---
    mov si, offset array + 1  ; Start from the second element
    mov cx, array_len - 1      ; Number of elements to sort

outer_loop_insertion:
    mov di, si                 ; Set insertion pointer
    mov al, [si]              ; Store current element in AL

inner_loop_insertion:
    cmp di, offset array      ; Check if reached the beginning
    jle end_inner_loop       ; If yes, end inner loop
    cmp al, [di-1]            ; Compare with the previous element
    jge end_inner_loop       ; If already in order, end inner loop
    mov ah, [di-1]            ; Shift larger element one position right
    mov [di], ah
    dec di                    ; Move insertion pointer one step back
    jmp inner_loop_insertion

end_inner_loop:
    mov [di], al              ; Insert current element at its sorted position
    inc si                    ; Move to the next element
    loop outer_loop_insertion
    ; --- End of Insertion Sort ---

    ; print sorted array
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    mov si, offset array
    mov cx, array_len
print_sorted:
    mov al, [si] 
    call print_number 
    mov dl, ' ' 
    mov ah, 02h
    int 21h
    inc si
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

    mov ah, 0   
    mov bl, 10  
    xor cx, cx 
convert_loop:
    div bl 
    push ax 
    inc cx 
    cmp al, 0 
    jne convert_loop

print_digits:
    pop ax 
    add ah, '0' 
    mov dl, ah 
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret
end start