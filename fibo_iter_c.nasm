BITS 64
CPU X64
DEFAULT REL

section .data
    int_fmt_string: db "%d", 0

section .text

extern _printf

; rdi=n
fibonacci_iter:
    mov rbx, 0 ; a
    mov rax, 1 ; b
    mov rcx, 1 ; i

    .loop:
        cmp rcx, rdi  ; i < n
        jge .end

        mov r8, rax ; tmp = b
        add rax, rbx ; b += a
        mov rbx, r8 ; a = tmp
        inc rcx ; i++
        jmp .loop

    .end:
        ; `rax` already contains the right value, `b`
        ret

global _main
_main:
    ; prolog
    push rbp
    mov rbp, rsp
    
    mov rdi, 35
    call fibonacci_iter

    mov rdi, int_fmt_string
    mov rsi, rax

    call _printf

    xor rax, rax

    ; epilog
    pop rbp
    ret
