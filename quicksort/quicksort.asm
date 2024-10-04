.model small
.stack 100h
.data
array db 1, 7, 5, 2, 3, 6, 4, 9, 8, 10
array_len equ $-array
msg1 db 'Original array: $', 0Dh, 0Ah, '$'
msg2 db 'Sorted array: $', 0Dh, 0Ah, '$'

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
    mov dl, ' '           ; Print a space
    mov ah, 02h
    int 21h
    inc si                 ; Move to the next number
    loop print_original

    ; --- Quicksort Implementation ---
    mov si, offset array   ; Point to the beginning of the array
    mov cx, array_len - 1  ; Length of the array (index of the last element)
    push cx                ; Push length of array onto stack
    push si                ; Push address of array onto stack
    call quicksort         ; Call quicksort function

    ; --- End of Quicksort ---

    ; print sorted array
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    mov si, offset array
    mov cx, array_len
print_sorted:
    mov al, [si]          ; Load number into AL
    call print_number     ; Call subroutine to print the number
    mov dl, ' '           ; Print a space
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
    inc cx       ; Increment digit counter
    cmp al, 0    ; Check if quotient is zero
    jne convert_loop

print_digits:
    pop ax       ; Get digit from stack
    add ah, '0'  ; Convert to ASCII
    mov dl, ah   ; Prepare for printing
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Quicksort subroutine
quicksort:
    push bp
    mov bp, sp
    sub sp, 4  ; allocate space for local variables
    push si
    push di

    mov si, [bp+4]  ; Address of the array
    mov cx, [bp+6]  ; Length of the array (last index)
    cmp si, cx
    jge quicksort_end

    ; Partition the array
    call partition
    mov di, ax      ; Index of the pivot

    ; Recursively sort the left partition
    push si         ; Start of left partition
    push di         ; End of left partition
    dec di
    call quicksort

    ; Recursively sort the right partition
    push di         ; Start of right partition
    inc di
    push cx         ; End of right partition
    call quicksort

quicksort_end:
    add sp, 4  ; deallocate space for local variables
    pop di
    pop si
    pop bp
    ret

; Partition subroutine
partition:
    push bp
    mov bp, sp
    sub sp, 4  ; allocate space for local variables
    push si
    push di

    mov si, [bp+4]  ; Start of array
    mov cx, [bp+6]  ; End of array
    mov di, si      ; Pivot index
    mov al, [si]    ; Pivot element in AL

    mov bx, cx      ; End of array for the comparison

partition_loop:
    cmp si, bx
    jge partition_done

    ; Move pointers to find misplaced elements
    ; Move si to the right while array[si] < pivot
    find_left:
        cmp byte ptr [si], al  ; Explicitly using byte ptr for 8-bit comparison
        jge find_right
        inc si
        jmp find_left

    ; Move bx to the left while array[bx] > pivot
    find_right:
        cmp byte ptr [bx], al ; Explicitly using byte ptr for 8-bit comparison
        jle skip_swap
        dec bx
        jmp find_right

    ; Swap elements
    skip_swap:
    cmp si, bx
    jge partition_done
    mov dl, [si]  ; Load value from [si] into DL
    mov dh, [bx]  ; Load value from [bx] into DH
    mov [si], dh  ; Store value from DH into [si]
    mov [bx], dl  ; Store value from DL into [bx]

    jmp partition_loop

partition_done:
    ; Place pivot in its correct position
    mov dl, [si]  ; Load value from [si] into DL
    mov dh, [di]  ; Load value from [di] into DH
    mov [si], dh  ; Store value from DH into [si]
    mov [di], dl  ; Store value from DL into [di]
    mov ax, si        ; Return pivot index
    add sp, 4  ; deallocate space for local variables
    pop di
    pop si
    pop bp
    ret

end start