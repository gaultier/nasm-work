; Prompt for a character on stdin and show it

BITS 64
CPU X64


%define stdin 0
%define stdout 1
%define stderr 2
%define syscall_exit 0x2000001
%define syscall_read 0x2000003
%define syscall_write 0x2000004

; Analog to write(2): ssize_t write(int fildes, const void *buf, size_t nbyte);
%macro write 3
    mov rax, syscall_write
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
    cmp rax, 2
    jl error
%endmacro

; Analog to read(2): ssize_t read(int fildes, void *buf, size_t nbyte)
%macro read 3
    mov rax, syscall_read
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
    cmp rax, 2
    jl error
%endmacro

global _start

section .data

	query_string:		db	"Enter a character:  "
	query_string_len:	equ	$ - query_string
	out_string:			db	"You have input:  "
	out_string_len:		equ	$ - out_string
        err_string: db "Error with syscall"
        err_string_len equ $- err_string

section .bss

	in_char:			resw 1 + 4

section .text

_start:
        ; show prompt
        write stdout, query_string, query_string_len

	; read in the character
        read stdin, in_char, 5 ; get 5 bytes from the kernel's buffer (one for the carriage return)
	; show user the output
        write stdout, out_string, out_string_len
        write stdout, in_char, 5

	; exit system call
	mov	rax, syscall_exit
	xor     rdi, rdi
	syscall

error:
    write stderr, err_string, err_string_len
    ; exit system call
    mov	rax, syscall_exit
    mov rdi, 1
    syscall
