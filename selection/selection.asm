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

    ; print original array (same as before)
    ; ...

    ; --- Selection Sort Implementation ---
    mov si, offset array       ; Start from the first element
    mov cx, array_len - 1      ; Number of passes

outer_loop_selection:
    mov di, si                 ; Set minimum index
    mov bx, si                 ; Set inner loop pointer

inner_loop_selection:
    inc bx                    ; Move to the next element
    cmp bx, offset array + array_len ; Check if reached the end
    jge end_inner_loop_selection  ; If yes, end inner loop
    mov al, [bx]              ; Load current element
    cmp al, [di]              ; Compare with the current minimum
    jge inner_ loop_selection  ; If not smaller, continue
    mov di, bx                ; Update minimum index
    jmp inner_loop_selection

end_inner_loop_selection:
    ; Swap minimum element with the first element of the unsorted portion
    mov al, [di]              ; Load minimum element
    xchg al, [si]             ; Exchange values directly in memory
    mov [di], al              ; 
    inc si                    ; Move to the next element
    loop outer_loop_selection
    ; --- End of Selection Sort ---

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