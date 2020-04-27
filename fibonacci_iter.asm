
BITS 64
CPU X64
DEFAULT REL


%define stdin 0
%define stdout 1
%define stderr 2
%define syscall_exit 0x2000001
%define syscall_write 0x2000004

; Analog to write(2): ssize_t write(int fildes, const void *buf, size_t nbyte);
%macro write 3
    mov rax, syscall_write
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
    mov rdx, rax,
    cmp rdx, 0
    jl error
%endmacro

%macro exit 1
    mov rdi, %1
    mov rax, syscall_exit
    syscall
%endmacro

; rdi=n
int_to_string:
    push rbp
    mov rbp, rsp
    sub rsp, 256
    lea r9, [rbp - 256]
    ;mov r9, [rbp] ; point at the end

    xor r8, r8 ; loop index i
    mov rax, rdi ; rax is the dividend

    .int_to_string_loop:
        cmp rax, 0 ; while (n != 0)
        jz .int_to_string_end

        mov rcx, 10 ; rcx is the dividor 
        xor rdx, rdx ; reset rem, otherwise we could get fpe
        div rcx ;  n /= 10; rdx = rem

        add rdx, '0' ; convert to ascii code

        ; *(--end) = rem
        dec r9
        mov [r9], dl 

        inc r8 ; i++
        jmp .int_to_string_loop

    .int_to_string_end:
        ; return i == strlen(s)
        mov rax, r8 
        write stdout, r9, r8

        add rsp, 256
        pop rbp
        ret


section .data
    err_string: db "Error with syscall"
    err_string_len: equ $- err_string

section .bss

    int_to_string_buf resw 256

section .text

error:
    write stderr, err_string, err_string_len
    exit rdx

global _start
_start:

    mov rdi, 456 ; n
    call int_to_string

    xor rax, rax
    exit rax
    
    ;mov r9, rax
    
    ;write stdout, rsi, r9

    ;exit r9

