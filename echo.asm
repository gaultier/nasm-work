; nasm -f macho64 echo.asm && ld -lSystem echo.o -o echo.exe

BITS 64
CPU X64
DEFAULT REL

section .text

extern _puts

global _main
_main:
    ; prolog
    push rbp
    mov rbp, rsp

    mov rdi, [rsi + 8] ; argv[1]
    call _puts

    xor rax, rax

    ; epilog
    pop rbp
    ret
