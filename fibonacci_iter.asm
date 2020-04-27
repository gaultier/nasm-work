; Prompt for a character on stdin and show it

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

int_to_string:
    xor r8, r8 ; loop index
    mov rax, rdi ; rax is the dividend
    lea rsi, [int_to_string_buf] ; our buffer in a register for relative addressing
    
    .int_to_string_loop:
        mov rcx, 10 ; rcx is the dividor 
        div rcx ; get rem in rdx
        cmp rdx, 0
        jz .int_to_string_end
        add rdx, '0' ; convert to ascii code
        mov [rsi + r8], rdx 
        inc r8

    .int_to_string_end:
        xor rax, rax
        ret

section .data
    err_string: db "Error with syscall"
    err_string_len: equ $- err_string

section .bss

    int_to_string_buf resw 256

section .text

global _start
_start:
    mov rdi, 32
    call int_to_string

    write stdout, int_to_string_buf, 2

    exit 0

error:
    write stderr, err_string, err_string_len
    exit rdx
