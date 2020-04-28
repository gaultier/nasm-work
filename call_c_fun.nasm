BITS 64
CPU X64
DEFAULT REL

extern _printf

%define stdin 0
%define stdout 1
%define stderr 2
%define syscall_exit 0x2000001
%define syscall_write 0x2000004

%macro exit 1
    mov rdi, %1
    mov rax, syscall_exit
    syscall
%endmacro


section .data
    err_string: db "Error with syscall"
    err_string_len: equ $- err_string
    fmt_string: db "`%d`", 0

section .bss

section .text

global main
main:
    ; prolog
    push rbp
    mov rbp, rsp
    and rsp, -16

    ; pass args
    mov rdi, fmt_string
    mov rsi, 42
    xor rdx, rdx
    xor rax, rax

    call _printf
    xor eax, eax
    
    ; epilog
    mov rsp, rbp
    pop rbp
    ret
