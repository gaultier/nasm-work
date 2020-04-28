; nasm -f macho64 echo.asm && ld -lc echo.o -o echo.exe

BITS 64
CPU X64
DEFAULT REL

section .text

%ifenv LINUX
    %define PUTS puts
%else
    %define PUTS _puts
%endif

extern PUTS

global _main
_main:
    ; prolog
    push rbp
    mov rbp, rsp

    mov rdi, [rsi + 8] ; argv[1]
    call PUTS

    xor rax, rax

    ; epilog
    pop rbp
    ret
