section .data
    array db 5, 3, 8, 1, 2     ; The array to be sorted
    array_len db 5              ; Length of the array
    msg db 'Sorted Array: ', 0   ; Message to print
    newline db 10                ; New line character

section .bss
    temp resb 1                  ; Temporary variable for swapping

section .text
    global _start

_start:
    ; Print the original array (optional)
    call print_array

    ; Bubble Sort Algorithm
    movzx ecx, byte [array_len]  ; Get the length of the array, zero-extend to ecx

outer_loop:
    dec ecx                       ; Decrement the outer loop counter
    mov ebx, 0                    ; Reset inner loop counter

    ; Inner Loop
inner_loop:
    mov al, [array + ebx]         ; Load current element
    mov dl, [array + ebx + 1]     ; Load next element
    cmp al, dl                    ; Compare elements
    jbe no_swap                   ; If current <= next, no swap needed

    ; Swap elements
    mov [temp], al                ; Store current in temp
    mov [array + ebx], dl         ; Move next to current
    mov al, [temp]                ; Move temp to al
    mov [array + ebx + 1], al     ; Move temp to next

no_swap:
    inc ebx                       ; Move to the next element
    cmp ebx, ecx                  ; Compare inner loop counter with length
    jl inner_loop                 ; If ebx < ecx, repeat inner loop

    ; Check if sorting is done
    cmp ecx, 1                    ; If only one element is left, we're done
    jg outer_loop                 ; If ecx > 1, repeat outer loop

    ; Print the sorted array
    call print_array

    ; Exit the program
    mov eax, 1                    ; Syscall number for exit
    xor ebx, ebx                  ; Return code 0
    int 0x80

; Function to print the array
print_array:
    ; Print the message
    mov edx, 15                   ; Length of the message
    mov ecx, msg                  ; Pointer to the message
    mov ebx, 1                    ; File descriptor (stdout)
    mov eax, 4                    ; Syscall number for write
    int 0x80

    ; Print the array elements
    movzx ecx, byte [array_len]   ; Get the length of the array
    mov ebx, 0                    ; Initialize index

print_loop:
    mov al, [array + ebx]         ; Load current element
    add al, '0'                   ; Convert to ASCII
    mov [temp], al                ; Store in temp

    ; Write the character
    mov edx, 1                    ; Write 1 byte
    mov ecx, temp                 ; Pointer to the character
    mov eax, 4                    ; Syscall number for write
    int 0x80

    ; Print newline after each element
    mov edx, 1                    ; Write 1 byte for newline
    mov ecx, newline              ; Pointer to newline
    mov eax, 4                    ; Syscall number for write
    int 0x80

    inc ebx                       ; Move to the next element
    cmp ebx, ecx                  ; Check if we've printed all elements
    jl print_loop                 ; If not, print next element

    ret
