BITS 64 ; 64 bits
CPU X64 ; target the x86_64 family of CPUs
DEFAULT REL ; relative addressing mode

extern _printf ; might be unused but that is ok

section .data
    string_fmt_string: db "%s", 0
    hello: db "hello, world", 0

section .text
global _main
_main:
    push rbp
    mov rbp, rsp

    xor rax, rax
    lea rdi, [string_fmt_string]
    lea rsi, [hello]
    call _printf

    xor rax, rax
    pop rbp
    ret

