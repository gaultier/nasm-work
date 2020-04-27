
BITS 64
CPU X64
DEFAULT REL


%define stdin 0
%define stdout 1
%define stderr 2

%ifenv LINUX
%define syscall_exit 60
%define syscall_write 1
%else
%define syscall_exit 0x2000001
%define syscall_write 0x2000004
%endif

; Analog to write(2): ssize_t write(int fildes, const void *buf, size_t nbyte);
%macro write 3
    mov rax, syscall_write
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro exit 1
    mov rdi, %1
    mov rax, syscall_exit
    syscall
%endmacro

; rdi=n
write_int_to_string:
    ; prolog
    push rbp
    mov rbp, rsp
    ; char s[256];
    sub rsp, 256
    lea r9, [rbp - 256] ; point at the end of the buffer

    xor r8, r8 ; loop index i
    mov rax, rsi ; rax is the dividend

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
        write rdi, r9, r8

        ; epilog
        add rsp, 256
        pop rbp
        ret


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

; rdi=n
fibonacci_rec:
    push r8
    push rbx

    mov rbx, rdi

    cmp rdi, 1
    jle .end

    mov rdi, rbx
    dec rdi  ; n-1
    call fibonacci_rec

    mov r8, rax ; store result in rbx
    
    add rbx, -2 ; n-2
    mov rdi, rbx
    call fibonacci_rec

    mov rbx, rax
    add rbx, r8 ; sum both results

    .end:
        mov rax, rbx

        pop rbx
        pop r8

        ret

section .data

section .bss

section .text


global _start
_start:

    mov rdi, 35
    call fibonacci_rec

    mov rdi, stdout
    mov rsi, rax ; n
    call write_int_to_string
    xor rax, rax

    exit rax

