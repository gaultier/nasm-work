
BITS 64 ; 64 bits
CPU X64 ; target the x86_64 family of CPUs
DEFAULT REL ; relative addressing mode

extern _printf ; might be unused but that is ok

section .data
    int_fmt_string: db "%d", 0

section .text
global _main
_main:
    push rbp
    mov rbp, rsp

    ;mov rsi, 4
    ;mov rax, rsi
    mov rax, 4
    cqo
    mov rcx, 2
    div rcx
    mov rsi, rax
    xor rax, rax

    lea rdi, [int_fmt_string]
    call _printf

    xor rax, rax
    pop rbp
    ret

